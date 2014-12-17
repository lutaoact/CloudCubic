'use strict'

express = require 'express'
controller = require './payment.controller'
auth = require("../../auth/auth.service")

router = express.Router()

# TODO: add auth.isAuthenticated()
router.get '/create_direct_pay_by_user', controller.create_direct_pay_by_user

alipay = require('./alipay_config').alipay;
alipay.route(router);

module.exports = router
