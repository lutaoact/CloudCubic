'use strict'

Broadcast = _u.getModel 'broadcast'

exports.index = (req, res, next) ->
  user = req.user
  Broadcast.findQ org: user.orgId
  .then (result) ->
    res.send result
  .catch next
  .done()


exports.create = (req, res, next) ->
  body =
    org: req.user.orgId
    content: req.body.content

  Broadcast.createQ body
  .then (broadcast) ->
    res.send 201, broadcast
  .catch next
  .done()


exports.destroy = (req, res, next) ->
  Broadcast.removeQ _id: req.params.id
  .then () ->
    res.send 204
  .catch next
  .done()
