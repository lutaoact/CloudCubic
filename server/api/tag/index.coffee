'use strict'

express = require 'express'
controller = require './tag.controller'
auth = require("../../auth/auth.service")
router = express.Router()

router.get  '/', controller.index
router.post '/', auth.isAuthenticated(), controller.create

module.exports = router
