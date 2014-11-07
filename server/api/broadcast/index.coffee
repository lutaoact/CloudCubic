'use strict'

express = require 'express'
controller = require './broadcast.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/',  auth.isAuthenticated(), controller.index
router.post '/', auth.hasRole('admin'), controller.create
router.delete '/:id', auth.hasRole('admin'), controller.destroy

module.exports = router
