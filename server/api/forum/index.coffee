"use strict"

express = require("express")
controller = require("./forum.controller")
auth = require("../../auth/auth.service")
router = express.Router()

# discussions
router.get '/', controller.index
router.get '/:id', controller.show
router.post '/', auth.isAuthenticated(), controller.create
router.put '/:id', auth.isAuthenticated(), controller.update
router.patch '/:id', auth.isAuthenticated(), controller.update
router.delete '/:id', auth.isAuthenticated(), controller.destroy
router.post '/:id/vote', auth.isAuthenticated(), controller.vote

module.exports = router
