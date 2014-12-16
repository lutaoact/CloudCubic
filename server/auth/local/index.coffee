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
    res.json(
      if req.org?
        token: token
      else
        host = user.orgId.customDomain ? user.orgId.uniqueName + '.' + req.headers.host
        targetUrl: req.protocol + '://' + host + '?access_token=' + token
    )
  )(req, res, next)

module.exports = router
