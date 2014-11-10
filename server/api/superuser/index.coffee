'use strict'

express = require 'express'
controller = require './superuser.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/org',     auth.hasRole('superuser'), controller.index
router.get '/org/:id', auth.hasRole('superuser'), controller.show

module.exports = router
