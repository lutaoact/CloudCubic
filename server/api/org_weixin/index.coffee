'use strict'

express = require 'express'
controller = require './org_weixin.controller'
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/me", auth.hasRole("admin"), controller.show
router.post "/", auth.hasRole("admin"), controller.upsert

module.exports = router
