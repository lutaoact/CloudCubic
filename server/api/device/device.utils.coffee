require '../../common/init'

fs = require 'fs'
cert = fs.readFileSync __dirname + '/../../cert/LeoPushCert.pem'
key  = fs.readFileSync __dirname + '/../../cert/LeoPushKey.pem'

apn = require 'apn'
BaiduPush = require "./baiduPush"
config = require '../../config/environment'
baiduPushServiceConfig = config.baiduPushService
baiduPushclient = new BaiduPush(baiduPushServiceConfig)

options =
  cert: cert
  key: key
  passphrase: 'password'

apnConnection = new apn.Connection(options)

Device = _u.getModel 'device'

class DeviceUtils
  classname: 'DeviceUtils'
  pushIos: (deviceToken, notice) ->
    console.log 'push ios', notice
    myDevice = new apn.Device(deviceToken)

    note = @_buildNote notice

    apnConnection.pushNotification note, myDevice

  pushAndroid: (deviceToken, notice) ->
    console.log 'push android', notice
    msg =
      push_type: 1
      message_type: 1
      user_id: deviceToken
      messages: JSON.stringify([
        #title: Const.Notification[notice.type] # TODO: add title
        description: Const.Notification[notice.type]
        custom_content: notice
      ])
      msg_keys: JSON.stringify(["key0"])

    baiduPushclient.pushMsg msg

  _buildNote: (notice) ->
    note = new apn.Notification()
    note.alert = Const.Notification[notice.type]
    note.sound = 'ping.aiff'
    note.payload.payload = JSON.stringify notice

    return note

  pushToUser: (notice) ->
    Device.getByUserId notice.userId
    .then (devices) =>
      _.each devices, (device) =>
        switch device.deviceType
          when 0
            @pushIos device.deviceToken, notice
          when 1
            @pushAndroid device.deviceToken, notice
          else
            throw new Error 'unknown deviceType' + device.deviceType
      return

exports.DeviceUtils = DeviceUtils
