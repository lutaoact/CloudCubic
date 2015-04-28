'use strict'

express = require 'express'
controller = require './active_time.controller'
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.hasRole("admin"), controller.index

module.exports = router
