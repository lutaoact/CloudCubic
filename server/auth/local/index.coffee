'use strict'

express = require('express')
passport = require('passport')
auth = require('../auth.service')
config = require('../../config/environment')

router = express.Router()

router.post '/', (req, res, next) ->
  passport.authenticate('local', (err, user, info) ->
    error = err ? info
    if error then return res.json(401, error)
    if !user then return res.json(404, {message: 'Something went wrong, please try again.'})

    token = auth.signToken(user._id, user.role)
    res.cookie('token', JSON.stringify(token), {expires: new Date(Date.now() + config.tokenExpireTime*60000)})
    res.json(
      if req.org?
        token: token
      else
        host = user.orgId.uniqueName + '.' + req.headers.host
        targetUrl: req.protocol + '://' + host + '/index?access_token=' + token
    )
  )(req, res, next)

module.exports = router
