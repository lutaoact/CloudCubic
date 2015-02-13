"use strict"

User = _u.getModel 'user'
Organization = _u.getModel 'organization'
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

  tmpResult = {}
  OrgUtils.check body.uniqueName
  .then () ->
    organization =
      uniqueName: body.orgUniqueName
      name      : body.orgName
      type      : body.orgType ? Const.OrgType.College
      location  : body.orgLocation

    Organization.createQ organization
  .then (org) ->
    tmpResult.org = org
    adminData =
      email   : body.email
      password: body.password
      name    : body.name
      orgId   : org._id
      role    : 'admin'

    User.createQ adminData
  .then (admin) ->
    tmpResult.admin = admin
    host = req.protocol+'://'+req.headers.host
    sendActivationMail admin.email, admin.activationCode, host, req.org?.name
  .then () ->
    OrgUtils.init tmpResult.admin, tmpResult.org
  .then () ->
    res.send
      email   : tmpResult.admin.email
      role    : tmpResult.admin.role
  .catch next
  .done()
