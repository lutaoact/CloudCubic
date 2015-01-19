require './initGlobal'

global.weixinAuth = {}

Organization = _u.getModel 'organization'
OrgWeixin = _u.getModel 'org_weixin'
OrgWeixin.findAllQ()
.then (docs) ->
  for doc in docs
    global.weixinAuth[doc.domain] = {appid: doc.appid, secret: doc.secret}

  console.log global.weixinAuth
, (err) ->
  logger.info err
  process.exit 0
