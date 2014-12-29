'use strict'

Comment = _u.getModel 'comment'
AdapterUtils = _u.getUtils 'adapter'
CommentUtils = _u.getUtils 'comment'
NoticeUtils = _u.getUtils 'notice'
DeviceUtils = _u.getUtils 'device'
SocketUtils = _u.getUtils 'socket'

WrapRequest = new (require '../../utils/WrapRequest')(Comment)

exports.index = (req, res, next) ->
  conditions = {}
  conditions.type = req.query.type if req.query.type
  conditions.belongTo = req.query.belongTo
  WrapRequest.wrapIndex req, res, next, conditions

exports.create = (req, res, next) ->
  user = req.user
  body = req.body
  data =
    content : body.content
    postBy  : user._id
    belongTo: body.belongTo
    type    : body.type
    tags    : body.tags

  console.log 'postBy type ', typeof data.postBy
  console.log 'belongTo', typeof data.belongTo
  
  
  Model = CommentUtils.getCommentRefByType body.type

  Model.updateQ {_id: data.belongTo}, {$inc: {commentsNum: 1}}
  .then (result) ->
    WrapRequest.wrapCreate req, res, next, data
  .then () ->
    #find all targeted users
    CommentUtils.getTargetUsers body.type, data.belongTo, data.postBy
  .then (targetUsers) ->  
    #console.log 'target users are', targetUsers
    notices = _.map targetUsers, (targetUser) ->
      NoticeUtils.addCommentNotice(
        targetUser
        user._id
        data.type
        data.belongTo
      )
    Q.allSettled (notices) 
  .then (notices) ->
      #console.log 'notices are' , notices
      SocketUtils.sendNotices notices
      DeviceUtils.pushToUser notice for notice in notices
  .catch next
  .done()

pickedUpdatedKeys = ['content', 'tags']
exports.update = (req, res, next) ->
  conditions = _id: req.params.id, postBy: req.user._id
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = _id: req.params.id, postBy: req.user._id
  WrapRequest.wrapDestroy req, res, next, conditions

exports.like = WrapRequest.wrapLike()
