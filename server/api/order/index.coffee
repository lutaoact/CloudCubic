'use strict'

express = require 'express'
controller = require './order.controller'
auth = require("../../auth/auth.service")

router = express.Router()

router.post '/', auth.isAuthenticated(), controller.create
router.get '/:id', auth.isAuthenticated(), controller.show
router.get '/:id/pay', auth.isAuthenticated(), controller.pay

alipay = require('./alipay_config').alipay;
alipay.route(router);

module.exports = router
