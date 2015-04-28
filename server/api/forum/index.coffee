"use strict"

express = require("express")
controller = require("./forum.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get '/', controller.index
router.get '/:id', controller.show
router.post '/', auth.isAuthenticated(), controller.create
router.put '/:id', auth.isAuthenticated(),  controller.update
router.patch '/:id', auth.isAuthenticated(), controller.update
router.delete '/:id', auth.isAuthenticated(), controller.destroy

router.get '/:id/tagsFreq', controller.tagsFreq

module.exports = router
