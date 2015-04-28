'use strict'

express = require 'express'
controller = require './cart.controller'
auth = require '../../auth/auth.service'
router = express.Router()

router.get '/', auth.isAuthenticated(), controller.show
router.post '/add', auth.isAuthenticated(), controller.add
router.post '/remove', auth.isAuthenticated(), controller.remove

module.exports = router
