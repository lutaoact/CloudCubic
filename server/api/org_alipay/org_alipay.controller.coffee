"use strict"

OrgAlipay = _u.getModel "org_alipay"
User = _u.getModel "user"


exports.show = (req, res, next) ->
  orgId = req.org._id
  OrgAlipay.findByOrgId orgId
  .then (orgAlipay) ->
    res.send orgAlipay
  , next


exports.update = (req, res, next) ->
  orgId = req.org.id
  OrgAlipay.findByOrgId orgId
  .then (orgAlipay) ->
    orgAlipay.PID = req.body.PID if req.body.PID
    orgAlipay.key = req.body.key if req.body.key
    orgAlipay.email = req.body.email if req.body.email
    orgAlipay.saveQ()
  .then (result) ->
    res.send result?[0]
  , next

