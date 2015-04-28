"use strict"

express = require("express")
controller = require("./org_alipay.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/me", auth.hasRole("admin"), controller.show
router.put "/me", auth.hasRole("admin"), controller.upsert
router.patch "/me", auth.hasRole("admin"), controller.upsert

router.get "/isSet", auth.hasRole("teacher"), controller.isSet

module.exports = router
