
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

exports.index = WrapRequest.wrapOrgIndex()

exports.show = (req, res, next) ->
  user = req.user
  classeId = req.params.id
  Classe.findOneQ
    _id: classeId
    orgId: user.orgId
  .then (classe) ->
    logger.info classe
    res.send classe
  , (err) ->
    console.log err
    next err

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
exports.create = WrapRequest.wrapOrgCreate pickedKeys

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

exports.destroy = WrapRequest.wrapDestroy()

exports.multiDelete = (req, res, next) ->
  ids = req.body.ids
  Classe.removeQ
    orgId: req.user.orgId
    _id: $in: ids
  .then () ->
    res.send 204
  , next
