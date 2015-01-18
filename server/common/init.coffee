require './initGlobal'

global.weixinAuth = {}

Organization = _u.getModel 'organization'
OrgWeixin = _u.getModel 'org_weixin'
OrgWeixin.getAllWithOrgPopulated()
.then (orgWeixins) ->
  for orgWeixin in orgWeixins
    global.weixinAuth[orgWeixin.orgId.customDomain] = {appid: orgWeixin.appid, secret: orgWeixin.secret}

  console.log global.weixinAuth
, (err) ->
  process.exit 0
