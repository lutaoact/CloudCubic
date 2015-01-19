'use strict'

OrgWeixin = _u.getModel 'org_weixin'
WrapRequest = new (require '../../utils/WrapRequest')(OrgWeixin)

exports.show = (req, res, next) ->
  conditions = {orgId: req.user.orgId}
  WrapRequest.wrapShow req, res, next, conditions


exports.upsert = (req, res, next) ->
  pickedKeys = ["domain", "appid", "secret"]
  update = _.pick req.body, pickedKeys
  OrgWeixin.findOneAndUpdateQ {orgId: req.user.orgId}, update, {upsert: true}
  .then (doc) ->
    global.weixinAuth[doc.domain] = {appid: doc.appid, secret: doc.secret}
    logger.info "current global.weixinAuth:", global.weixinAuth
    res.send doc
  .catch next
  .done()
