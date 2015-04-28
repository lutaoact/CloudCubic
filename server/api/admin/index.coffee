'use strict'

express = require 'express'
controller = require './admin.controller'
auth = require '../../auth/auth.service'
router = express.Router()

router.post '/enrollStudent', auth.hasRole('admin'), controller.enrollStudent

module.exports = router
