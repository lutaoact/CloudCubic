global.weixinAuth = {}

setWeixinAuth = (key, value) ->
  global.weixinAuth[key] = value

OrgWeixin = _u.getModel 'org_weixin'
OrgWeixin.findAllQ()
.then (docs) ->
  for doc in docs
    setWeixinAuth doc.domain, {appid: doc.appid, secret: doc.secret}
, (err) ->
  logger.info err
  process.exit 0

global.setWeixinAuth = setWeixinAuth
