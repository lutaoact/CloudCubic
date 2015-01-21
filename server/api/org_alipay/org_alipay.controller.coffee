"use strict"

OrgAlipay = _u.getModel "org_alipay"
WrapRequest = new (require '../../utils/WrapRequest')(OrgAlipay)

exports.show = (req, res, next) ->
  conditions = {orgId: req.user.orgId}
  WrapRequest.wrapShow req, res, next, conditions


exports.upsert = (req, res, next) ->
  pickedKeys = ["PID", "key", "email"]
  update = _.pick req.body, pickedKeys
  OrgAlipay.findOneAndUpdateQ {orgId: req.user.orgId}, update, {upsert: true}
  .then (doc) ->
    res.send doc
  .catch next
  .done()


exports.isSet = (req, res, next) ->
  conditions = {orgId: req.org?._id}
  OrgAlipay.findOneQ conditions
  .then (doc) ->
    res.send doc?
  .catch next
  .done()
