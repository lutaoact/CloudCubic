"use strict"

express = require("express")
controller = require("./organization.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.hasRole("admin"), controller.index
router.get "/me", auth.isAuthenticated(), controller.me
router.get "/check", controller.check
router.get "/:id", auth.hasRole("admin"), controller.show
router.post "/", auth.hasRole("superuser"), controller.create
router.put "/:id", auth.hasRole("admin"), controller.update
router.patch "/:id", auth.hasRole("admin"), controller.update
router.delete "/:id", auth.hasRole("superuser"), controller.destroy

module.exports = router
