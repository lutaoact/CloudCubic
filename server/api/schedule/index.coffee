"use strict"

express = require("express")
controller = require("./schedule.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.isAuthenticated(), controller.index
router.post "/", auth.hasRole('teacher'), controller.create
router.put "/", auth.hasRole('admin'), controller.upsert
router.delete "/:id", auth.hasRole('teacher'), controller.destroy

module.exports = router
