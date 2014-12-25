"use strict"

express = require("express")
controller = require("./course.controller")
auth = require("../../auth/auth.service")
router = express.Router()

# course
router.get "/", auth.verifyTokenCookie(), controller.index
router.get "/:id", controller.show
router.post "/", auth.hasRole("teacher"), controller.create
router.put "/:id", auth.hasRole("teacher"), controller.update
router.patch "/:id", auth.hasRole("teacher"), controller.update
router.delete '/:id', auth.hasRole('teacher'), controller.destroy

router.post '/:id/publish', auth.hasRole('teacher'), controller.publish

module.exports = router
