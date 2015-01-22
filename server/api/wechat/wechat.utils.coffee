require '../../common/init'
BaseUtils = require('../../common/BaseUtils')
request = require 'request'

redisClient = require '../../common/redisClient'

tokenUrlFormat = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s"
redisKeySuffix = '_access_token'
console.log tokenUrlFormat
threeMinutes = 3 * 60

class WechatUtils extends BaseUtils
  classname: 'WechatUtils'

  getAccessToken: (domain, appid, secret, cb) ->
    key = "#{domain}#{redisKeySuffix}"
    logger.info key
    redisClient.q.get key
    .then (token) ->
      if token then return cb null, token

      tokenUrl = _s.sprintf tokenUrlFormat, appid, secret
      request tokenUrl, (err, res, body) ->
        if err then return cb err

        obj = JSON.parse body
        # 设置token的过期时间为expires_in - 3分钟，以便提前刷新token
        redisClient.q.setex key, ~~obj.expires_in - threeMinutes, obj.access_token
        cb null, obj.access_token
    , (err) ->
      cb err

  getAccessTokenQ: () ->
    return Q.nfapply (Q.nbind @getAccessToken, @), arguments

exports.WechatUtils = WechatUtils
