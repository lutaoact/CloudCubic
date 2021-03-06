'use strict'

OrgWeixin = _u.getModel 'org_weixin'
WrapRequest = new (require '../../utils/WrapRequest')(OrgWeixin)

exports.show = (req, res, next) ->
  conditions = {orgId: req.user.orgId}
  WrapRequest.wrapShow req, res, next, conditions


exports.upsert = (req, res, next) ->
  pickedKeys = ["domain", "appid", "secret", 'gongappid', 'gongsecret']
  update = _.pick req.body, pickedKeys
  OrgWeixin.findOneAndUpdateQ {orgId: req.user.orgId}, update, {upsert: true}
  .then (doc) ->
    # 将更新之后的新域名配置信息更新到全局对象中去
    global.setWeixinAuth doc.domain, {appid: doc.appid, secret: doc.secret, gongappid: doc.gongappid, gongsecret: doc.gongsecret}
    logger.info "current global.weixinAuth:", global.weixinAuth
    res.send doc
  .catch next
  .done()


exports.isSet = (req, res, next) ->
  conditions = {orgId: req.org?._id}
  OrgWeixin.findOneQ conditions
  .then (doc) ->
    res.send doc?
  .catch next
  .done()
