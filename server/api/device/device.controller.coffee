'use strict'

Device = _u.getModel 'device'

exports.register = (req, res, next) ->
  user = req.user
  deviceToken = req.body.deviceToken
  deviceType = req.body.deviceType

  console.log 'register device', user, deviceToken, deviceType

  Device.getOne user._id, deviceToken, deviceType
  .then (device) ->
    if device?
      return device
    else
      Device.createOne user._id, deviceToken, deviceType
  .then (device) ->
    res.send device
  .catch next
  .done()

exports.unregister = (req, res, next) ->
  user = req.user
  deviceToken = req.body.deviceToken
  deviceType = req.body.deviceType

  console.log 'unregister device', user, deviceToken, deviceType

  Device.getOne user._id, deviceToken, deviceType
  .then (device) ->
    if device?
      return device.removeQ()
  .then () ->
    res.send 204
  .catch next
  .done()
