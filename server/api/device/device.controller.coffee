'use strict'

Device = _u.getModel 'device'

exports.register = (req, res, next) ->
  user = req.user
  deviceToken = req.body.deviceToken

  Device.getOne user._id, deviceToken
  .then (device) ->
    if device?
      return device
    else
      Device.createOne user._id, deviceToken
  .then (device) ->
    res.send device
  .catch next
  .done()

exports.unregister = (req, res, next) ->
  user = req.user
  deviceToken = req.body.deviceToken

  Device.getOne user._id, deviceToken
  .then (device) ->
    if device?
      return device.removeQ()
  .then () ->
    res.send 204
  .catch next
  .done()
