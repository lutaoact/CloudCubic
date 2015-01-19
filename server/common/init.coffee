require './initGlobal'

global.weixinAuth = {}

Organization = _u.getModel 'organization'
OrgWeixin = _u.getModel 'org_weixin'
OrgWeixin.findAllQ()
.then (orgWeixins) ->
  for orgWeixin in orgWeixins
    global.weixinAuth[orgWeixin.domain] = {appid: orgWeixin.appid, secret: orgWeixin.secret}

  console.log global.weixinAuth
, (err) ->
  logger.info err
  process.exit 0
