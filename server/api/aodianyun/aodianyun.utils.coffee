BaseUtils = require('../../common/BaseUtils')
crypto = require 'crypto'

APPID     = '737539036116'
APPSECRET = 'PUye0M27PhZxg6FVo20seI9646G1xGy6'

request = require 'request'

getAppUrl     = 'http://openapi.aodianyun.com/v2/LSS.GetApp'
openAppUrl    = 'http://openapi.aodianyun.com/v2/LSS.OpenApp'
closeAppUrl   = 'http://openapi.aodianyun.com/v2/LSS.CloseApp'
restartAppUrl = 'http://openapi.aodianyun.com/v2/LSS.RestartApp'

class AodianyunUtils extends BaseUtils
  openThenStart: (appid, appname) ->
    @getAppQ()
    .then (appids) =>
      unless _u.contains appids, appid
        @openAppQ appid, appname

  getApp: (cb) ->
    parameter = JSON.stringify({access_id: APPID, access_key: APPSECRET})
    #json: true这个参数会将相应的body自动解析
    request.post getAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb {errMsg: err}
      unless body.Flag is 100 then return cb {errMsg: body.FlagString} #body.Flag不为100，则表示出错

      cb null, _.pluck body.List, 'appid'

  getAppQ: () ->
    return Q.nfapply (Q.nbind @getApp, @), arguments

  openApp: (appid, appname, cb) ->
    parameter = JSON.stringify(
      access_id: APPID
      access_key: APPSECRET
      appid: appid
      appname: appname
    )
    #json: true这个参数会将相应的body自动解析
    request.post openAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb {errMsg: err}
      unless body.Flag is 100 then return cb {errMsg: body.FlagString} #body.Flag不为100，则表示出错

      cb()

  openAppQ: () ->
    return Q.nfapply (Q.nbind @openApp, @), arguments

  closeApp: (appid, cb) ->
    parameter = JSON.stringify(
      access_id: APPID
      access_key: APPSECRET
      appid: appid
    )
    #json: true这个参数会将相应的body自动解析
    request.post closeAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb {errMsg: err}
      unless body.Flag is 100 then return cb {errMsg: body.FlagString} #body.Flag不为100，则表示出错

      cb()

  closeAppQ: () ->
    return Q.nfapply (Q.nbind @closeApp, @), arguments

  restartApp: (appid, cb) ->
    parameter = JSON.stringify(
      access_id: APPID
      access_key: APPSECRET
      appid: appid
    )
    #json: true这个参数会将相应的body自动解析
    request.post restartAppUrl, {form: {parameter: parameter}, json: true}, (err, res, body) ->
      if err then return cb err
      unless body.Flag is 100 then return cb body.FlagString #body.Flag不为100，则表示出错

      cb()

  restartAppQ: () ->
    return Q.nfapply (Q.nbind @restartApp, @), arguments


  # deprecated
  generateAppid: (data) ->
    result = crypto.createHash('sha1').update(data).digest('hex')
    return result.substr(0, 20)

exports.Class = AodianyunUtils
exports.Instance = new AodianyunUtils()
exports.AodianyunUtils = AodianyunUtils
