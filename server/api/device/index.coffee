'use strict'

express = require 'express'
controller = require './device.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.post '/register', auth.isAuthenticated(), controller.register
router.post '/unregister', auth.isAuthenticated(), controller.unregister

module.exports = router
