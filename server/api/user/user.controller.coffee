'use strict'

User = _u.getModel "user"
Classe = _u.getModel 'classe'
AssetUtils = _u.getUtils 'asset'
passport = require 'passport'
config = require '../../config/environment'
jwt = require 'jsonwebtoken'
qiniu = require 'qiniu'
path = require 'path'
_ = require 'lodash'
fs = require 'fs'
request = require 'request'
xlsx = require 'node-xlsx'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
Organization = _u.getModel "organization"
UserUtils = _u.getUtils 'user'
crypto = require 'crypto'
sendActivationMail = require('../../common/mail').sendActivationMail
sendPwdResetMail = require('../../common/mail').sendPwdResetMail
setTokenCookie = require('../../auth/auth.service').setTokenCookie

qiniu.conf.ACCESS_KEY = config.qiniu.access_key
qiniu.conf.SECRET_KEY = config.qiniu.secret_key
qiniuDomain           = config.assetsConfig[config.assetHost.uploadFileType].domain
uploadImageType       = config.assetHost.uploadImageType

###
  Get list of users
  restriction: 'admin'
###
exports.index = (req, res, next) ->
  condition =
    orgId : req.user.orgId
  condition.role = req.query.role if req.query.role?

  console.log req.query

  if req.query.role is 'student' and req.query.standalone is 'true'
    allStudents = []
    User.findQ condition, '-salt -hashedPassword'
    .then (users) ->
      allStudents = _.map users, (user) -> user.profile
      Classe.findQ
        orgId : req.user.orgId
    .then (classes) ->
      classStudents = {}
      _.forEach classes, (classe) ->
        _.forEach classe.students, (studentId) ->
          classStudents[studentId] = studentId

      results = _.filter allStudents, (as) ->
        not classStudents[as._id]?

      res.send results
    .catch next
    .done()

  else
    User.findQ condition, '-salt -hashedPassword'
    .then (users) ->
      res.send users
    .catch next
    .done()

###
  Creates a new user
###
exports.create = (req, res, next) ->
  body = req.body
  body.provider = 'local'

  delete body._id
  body.orgId = req.user.orgId

  User.createQ body
  .then (user) ->
    host = req.protocol+'://'+req.headers.host
    sendActivationMail user.email, user.activationCode, host, req.org?.name
    if req.user.role is 'admin'
      res.json user
    else
      token = jwt.sign
        _id: user._id,
        config.secrets.session,
        expiresInMinutes: 60*5
      res.json
        _id: user._id
        token: token
  , next

###
  Get a single user
###
exports.show = (req, res, next) ->
  userId = req.params.id
  User.findByIdQ userId
  .then (user) ->
    res.send user.profile
  .catch next
  .done()


exports.check = (req, res, next) ->
  UserUtils.check
    orgId: req.org?.id
    email: req.query.email
  .then () ->
    res.send 200
  .catch next
  .done()

###
  Get a single user by email
###
exports.showByEmail = (req, res, next) ->
  User.findOneQ
    email : req.params.email
  .then (user) ->
    return res.send 404 if not user?
    res.send user.profile
  , next

###
  Deletes a user
  restriction: 'admin'
###
exports.destroy = (req, res, next) ->
  userId = req.params.id
  userObj = undefined
  User.removeQ
    orgId: req.user.orgId
    _id: userId
  .then (user) ->
    userObj = user
    Classe.findQ
      students : userId
  .then (classes) ->
    if classes?
      promiseAll = for classe in classes
        classe.updateQ $pull: students: userId
      Q.all promiseAll
  .then () ->
    res.send userObj
  , next

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  UserUtils.multiDelete req.user, ids
  .then (classes) ->
    res.send classes
  .catch next
  .done()

###
  Change a users password
###
exports.changePassword = (req, res, next) ->
  userId = req.user._id
  oldPass = String req.body.oldPassword
  newPass = String req.body.newPassword

  User.findByIdQ userId
  .then (user) ->
    if user.authenticate oldPass
      user.password = newPass
      user.save (err) ->
        return next err if err
        res.send 200
    else
      res.send 403
  , next


###
  Get my info
###
exports.me = (req, res, next) ->
  userId = req.user.id
  User.findOne
    _id: userId
    '-salt -hashedPassword'
  .populate 'orgId'
  .execQ()
  .then (user) -> # donnot ever give out the password or salt
    return res.send 401 if not user?
    res.send user
  , next

###
  Update user
###
exports.update = (req, res, next) ->
  body = req.body
  body = _.omit body, ['_id', 'password', 'orgId']

  User.findByIdQ req.params.id
  .then (user) ->
    return res.send 404 if not user?

    updated = _.merge user , req.body
    updated.saveQ()
  .then (result) ->
    res.send result[0]
  , next


updateClasseStudents = (classeId, studentList) ->
  Classe.findByIdQ(classeId)
  .then (classe) ->
    return Q.reject 'No classe found for give ID' if not classe?

    logger.info 'Found classe with id ' + classe.id
    # remove duplicate students from list
    classe.students = _.uniq (_.union classe.students, studentList), (s) ->
      s.toString()
    classe.markModified 'students'
    classe.saveQ()

###
  Bulk import users from excel sheet uploaded by client
###
exports.bulkImport = (req, res, next) ->
  orgId = req.user.orgId
  resourceKey = decodeURI(req.body.key.replace(/.*images\/\d+\//, ''))
  type = req.body.type
  classeId = req.body.classeId

  console.log 'start importing...', resourceKey

  # do some sanity check
  if !type? or !orgId?
    return res.send 400, '参数不正确'

  destFile = config.local.tempDir + path.sep + 'user_list.xlsx'
  stream = fs.createWriteStream destFile
  streamOnQ = Q.nbind stream.on, stream
  streamCloseQ = Q.nbind stream.close, stream

  importReport =
    total : 0
    success : []
    failure : []

  importedUsers = []

  userList = []

  AssetUtils.getAssetFromQiniu(resourceKey, uploadImageType)
  .then (downloadUrl) ->
    request.get(downloadUrl).pipe stream
    streamOnQ 'finish'
  .then ->
    streamCloseQ()
  .then ->

    # 增加对Excel格式容错的逻辑：

    isEmail = (input) ->  /\S+@\S+\.\S+/.test(input)

    # 取第一个‘符合Email格式的’的为Email
    getEmail = (itemArray) -> _.find itemArray, isEmail

    # 取第一个‘不符合Email格式的’符号的为姓名
    getName = (itemArray) -> _.find itemArray, (item) -> !isEmail(item)

    # 取Email中‘@’之前的字符作为姓名
    getNameFromEmail = (itemArray) -> getEmail(itemArray)?.replace(/(.*)@.*/g, '$1')

    sheets = xlsx.parse destFile
    userList = _.map sheets[0].data, (userItemArray) ->
      email: getEmail(userItemArray)
      name: getName(userItemArray) ? getNameFromEmail(userItemArray)
      info: userItemArray.join(', ') # 信息join起来都放到 user.info (备注) 里面

    if not userList
      logger.error 'Failed to parse user list file or empty file'
      Q.reject '请导入包含用户信息的表格'

    console.log 'check user exists...'
    # for existing students, don't need to import it
    # just add it to importedUsers list
    existingStudentPromises = _.map userList, (userItem) ->
      User.findQ
        orgId : orgId
        email : userItem.email

    Q.allSettled(existingStudentPromises)
  .then (results) ->

    # filter out existing users from userList
    _.forEach results, (result) ->
      if (result.state is 'fulfilled') && (result.value.length > 0) && (type is 'student')

        foundUser = result.value[0]
        importReport.success.push foundUser.name
        importedUsers.push foundUser.id

        # remove this user from UserList
        # fix： 这里不能取 result 的 index，因为 result 的 length 不一定是 userList 的 length
        removeIndex = _.findIndex userList, email:foundUser.email
        userList.splice removeIndex, 1

    savePromises = _.map userList, (userItem) ->
      newUser = new User.model
        role : type
        orgId : orgId
        name : userItem.name
        info : userItem.info
        email : userItem.email
        password : userItem.email #initial password is the same as email
      newUser.saveQ()

    Q.allSettled(savePromises)
  .then (results) ->
    _.forEach results, (result) ->
      if result.state is 'fulfilled'
        user = result.value[0]
        host = req.protocol+'://'+req.headers.host
        sendActivationMail user.email, user.activationCode, host, req.org?.name
        console.log 'Imported user ' + user.name
        importReport.success.push user.name
        importedUsers.push user.id
      else
        console.error 'Failed to import user', result.reason
        importReport.failure.push result.reason

    if type is 'student' && !_.isEmpty(classeId)
      updateClasseStudents classeId, importedUsers
  .then ->
    res.send importReport

  .catch (err) ->
    logger.error 'import users error: ' + err
    fs.unlink destFile
    next err


exports.forgotPassword = (req, res, next) ->
  if not req.body.email? then return res.send 400

  cryptoQ = Q.nbind(crypto.randomBytes)
  token = null

  cryptoQ(21)
  .then (buf) ->
    token = buf.toString 'hex'
    conditions =
      orgId: req.org?.id
      email: req.body.email.toLowerCase()
    fieldsToSet =
      resetPasswordToken: token,
      resetPasswordExpires: Date.now() + 10000000
    User.findOneAndUpdateQ conditions, fieldsToSet
  .then (user) ->
    return res.send(403, "该邮箱地址还未注册，请确认您输入的邮箱地址是否正确") if !user?
    host = req.protocol+'://'+req.headers.host
    sendPwdResetMail user.name, user.email, host, token, req.org?.name
  .done () ->
    res.send 200
  , next


exports.resetPassword = (req, res, next) ->
  if not req.body.password? then return res.send 400

  User.findOneQ
    email: req.body.email?.toLowerCase?()
    resetPasswordToken: req.body.token
    resetPasswordExpires:
      $gt: Date.now()
  .then (user) ->
    return res.send(403, "重设密码链接已过时或者不合法") if !user?
    user.password = req.body.password
    user.saveQ()
  .then (saved) ->
    res.send 200
  , next


exports.sendActivationMail = (req, res, next) ->
  User.findOneQ
    orgId: req.org?.id ? req.body.orgId
    email: req.body.email
  .then (user) ->
    host = req.protocol+'://'+req.headers.host
    sendActivationMail user.email, user.activationCode, host, req.org?.name
    res.send 200
  .catch next
  .done()


exports.completeActivation = (req, res, next) ->
  User.findOneQ
    email: req.query.email?.toLowerCase?()
    activationCode: req.query.activation_code
  .then (user) ->
    if not user?
      return res.redirect "/index?message=activation-none"
    req.user = user
    if user.status == 1
      return res.redirect "/index?message=activation-used"
    user.status = 1
    user.saveQ()
  .then ()->
    setTokenCookie req, res, "/index?message=activation-success"
  .catch next
  .done()

###
 Authentication callback
###
exports.authCallback = (req, res, next) ->
  res.redirect '/'
