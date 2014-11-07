'use strict'

express = require 'express'
controller = require './super.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/org',     auth.hasRole('super'), controller.index
router.get '/org/:id', auth.hasRole('super'), controller.show

module.exports = router
