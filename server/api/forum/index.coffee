"use strict"

express = require("express")
controller = require("./forum.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get '/', controller.index
router.get '/:id', controller.show
router.post '/', auth.hasRole('teacher'), controller.create
router.put '/:id', auth.hasRole('teacher'),  controller.update
router.patch '/:id', auth.hasRole('teacher'), controller.update
router.delete '/:id', auth.hasRole('teacher'), controller.destroy

router.get '/:id/topicsNum', controller.topicsNum

module.exports = router
