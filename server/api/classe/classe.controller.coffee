
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /classe              ->  index
# * POST    /classe              ->  create
# * GET     /classe/:id          ->  show
# * PUT     /classe/:id          ->  update
# * PATCH   /classe/:id          ->  update
# * DELETE  /classe/:id          ->  destroy
# * POST    /classe/multiDelete  ->  destroy
#
"use strict"

Classe = _u.getModel "classe"
WrapRequest = new (require '../../utils/WrapRequest')(Classe)

exports.index = (req, res, next) ->
  conditions = orgId: req.org?._id
  conditions.courseId = req.query.courseId if req.query.courseId
  conditions.students = req.query.studentId if req.query.studentId

  WrapRequest.wrapPageIndex req, res, next, conditions


exports.show = (req, res, next) ->
  conditions = _id: req.params.id, orgId: req.user.orgId
  WrapRequest.wrapShow req, res, next, conditions


exports.showStudents = (req, res, next) ->
  user = req.user
  classeId = req.params.id

  Classe.findOne
    _id: classeId
    orgId: user.orgId
  .populate 'students'
  .execQ()
  .then (classe) ->
    res.send classe.students
  , next

pickedKeys = ["name", "courseId", "enrollment", "duration", "price"]
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  data.orgId = req.user.orgId
  WrapRequest.wrapCreate req, res, next, data


exports.update = (req, res, next) ->
  classeId = req.params.id
  body = req.body
  delete body._id if body._id

  Classe.findByIdQ classeId
  .then (classe) ->
    updated = _.extend classe, body
    do updated.saveQ
  .then (result) ->
    newClasse = result[0]
    logger.info newClasse
    res.send newClasse
  , next

exports.destroy = (req, res, next) ->
  conditions = _id: req.params.id, orgId: req.org?._id
  WrapRequest.wrapDestroy req, res, next, conditions

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  Classe.removeQ
    orgId: req.user.orgId
    _id: $in: ids
  .then () ->
    res.send 204
  , next

exports.enroll = (req, res, next) ->
  classeId = req.params.id
  user = req.user

  Classe.findOneQ _id: classeId, orgId: user.orgId
  .then (classe) ->
    unless classe
      return Q.reject
        status: 403
        errCode: ErrCode.NoClasse
        errMsg: '班级不存在或者不属于当前登录用户的机构'

    console.log classe.price
    if classe.price != 0
      return Q.reject
        status: 403
        errCode: ErrCode.NotFreeClasse
        errMsg: '该课程收费'

    classe.students.addToSet user._id
    do classe.saveQ
  .then (classe) ->
    res.send classe
  .catch next
  .done()
