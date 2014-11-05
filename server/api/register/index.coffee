"use strict"

express = require("express")
controller = require("./register.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.post "/user", controller.createUser
router.post "/org",  controller.createOrg

module.exports = router
