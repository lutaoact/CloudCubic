"use strict"

express = require("express")
controller = require("./classe.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index
router.get "/:id", auth.hasRole('teacher'), controller.show
router.get "/:id/students", auth.hasRole("teacher"), controller.showStudents
router.post "/", auth.hasRole("teacher"), controller.create
router.put "/:id", auth.hasRole("teacher"), controller.update
router.patch "/:id", auth.hasRole("teacher"), controller.update
router.delete '/:id', auth.hasRole('teacher'), controller.destroy
router.post "/multiDelete", auth.hasRole("teacher"), controller.multiDelete

router.post "/:id/enroll", auth.isAuthenticated(), controller.enroll

module.exports = router
