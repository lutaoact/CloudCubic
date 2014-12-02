"use strict"

express = require("express")
controller = require("./bind.controller")
auth = require("../../auth/auth.service")
router = express.Router()

# course
router.post "/weibo", auth.isAuthenticated(), controller.bindWeibo
router.post "/qq",    auth.isAuthenticated(), controller.bindQQ

module.exports = router
