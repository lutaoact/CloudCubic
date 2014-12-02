'use strict'

Device = _u.getModel 'device'

exports.register = (req, res, next) ->
  user = req.user
  deviceToken = req.body.deviceToken
  deviceType = req.body.deviceType

  console.log 'register device', user._id, deviceToken, deviceType

  Device.getOne deviceToken, deviceType
  .then (device) ->
    if device?
      if device.userId is user._id
        return device
      else
        device.removeQ()
        .then ()->
          Device.createOne user._id, deviceToken, deviceType
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

  console.log 'unregister device', user._id, deviceToken, deviceType

  Device.getOne deviceToken, deviceType
  .then (device) ->
    if device?
      return device.removeQ()
  .then () ->
    res.send 204
  .catch next
  .done()
