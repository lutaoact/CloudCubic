"use strict"

User = _u.getModel 'user'
Organization = _u.getModel 'organization'
OrgAlipay = _u.getModel 'org_alipay'
UserUtils = _u.getUtils 'user'
OrgUtils  = _u.getUtils 'organization'
sendActivationMail = require('../../common/mail').sendActivationMail

exports.createUser = (req, res, next) ->
  body = req.body

  user =
    email   : body.email
    password: body.password
    name    : body.name
    orgId   : req.org?._id

  User.createQ user
  .then (result) ->
    host = req.protocol+'://'+req.headers.host
    sendActivationMail result.email, result.activationCode, host, req.org?.name
    res.send
      email: result.email
      role: result.role
  .catch next
  .done()


exports.createOrg = (req, res, next) ->
  body = req.body
  logger.info "body: ", body

  OrgUtils.check body.uniqueName
  .then () ->
    UserUtils.check email: body.email
  .then () ->
    organization =
      uniqueName: body.orgUniqueName
      name      : body.orgName
      type      : body.orgType ? Const.OrgType.College
      location  : body.orgLocation

    Organization.createQ organization
  .then (org) ->
    admin =
      email   : body.email
      password: body.password
      name    : body.name
      orgId   : org._id
      role    : 'admin'

    alipayInfo =
      orgId : org._id
      email : body.orgAlipayEmail
      PID   : body.orgAlipayPID
      key   : body.orgAlipayKey

    Q.all [
      User.createQ admin
      OrgAlipay.createQ alipayInfo
    ]
  .spread (user, orgAlipay) ->
    host = req.protocol+'://'+req.headers.host
    sendActivationMail user.email, user.activationCode, host, req.org?.name
    res.send
      email   : user.email
      role    : user.role
  .catch next
  .done()
