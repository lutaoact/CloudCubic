"use strict"

User = _u.getModel 'user'
Organization = _u.getModel 'organization'

exports.createUser = (req, res, next) ->
  body = req.body

  user =
    username: body.username
    email: body.username
    password: body.password

  User.createQ user
  .then (result) ->
    res.send
      username: result.username
      email: result.email
  .catch next
  .done()


exports.createOrg = (req, res, next) ->
  body = req.body
  organization =
    uniqueName: body.uniqueName
    name: body.name
    type: body.type ? Const.OrgType.Colledge

  Organization.createQ organization
  .then (org) ->
    admin =
      username: body.username
      email: body.username
      orgId: org._id

    User.createQ admin
  .then (result) ->
    res.send
      username: result.username
      email: result.email
  .catch next
  .done()
