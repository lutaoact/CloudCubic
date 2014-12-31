'use strict'

Notice = _u.getModel 'notice'

WrapRequest = new (require '../../utils/WrapRequest')(Notice)

exports.index = (req, res, next) ->
  userId = req.user.id

  conditions = {}
  conditions.userId = userId
  if !req.query.all
    conditions.status = 0
  WrapRequest.wrapIndex req, res, next, conditions

exports.read = (req, res, next) ->
  ids = req.body.ids
  Notice.updateQ
    _id: $in: ids
    userId: req.user._id
  ,
    $set: status: 1 #status: 1 -> read
  ,
    multi: true
  .then (result) ->
    res.send 200, result[1]
  , next
