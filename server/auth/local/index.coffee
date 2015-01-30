'use strict'

express = require('express')
passport = require('passport')
auth = require('../auth.service')

router = express.Router()

router.post '/', (req, res, next) ->
  passport.authenticate('local', (err, user, info) ->
    error = err ? info
    if error then return res.json(401, error)
    if !user then return res.json(404, {message: 'Something went wrong, please try again.'})

    token = auth.signToken(user._id, user.role)
    domainPath = if req.url.indexOf('/mobile') is 0 then '/mobile' else '/'
    #TODO: config the cookie & token expiration time
    res.cookie('token', JSON.stringify(token), {path: domainPath, expires: new Date(Date.now() + 60*24*7*60000)})
    res.json(
      if req.org?
        token: token
      else
        host = user.orgId.uniqueName + '.' + req.headers.host
        targetUrl: req.protocol + '://' + host + '/index?access_token=' + token
    )
  )(req, res, next)

module.exports = router
