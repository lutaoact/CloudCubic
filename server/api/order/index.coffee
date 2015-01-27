'use strict'

express = require 'express'
controller = require './order.controller'
auth = require("../../auth/auth.service")

router = express.Router()

router.get '/', auth.isAuthenticated(), controller.index
router.post '/', auth.isAuthenticated(), controller.create
router.get '/count' , auth.isAuthenticated(), controller.count
router.get '/report', auth.hasRole('admin'), controller.report
router.get '/:id', auth.isAuthenticated(), controller.show
router.get '/:id/pay', auth.isAuthenticated(), controller.pay
router.delete '/:id', auth.isAuthenticated(), controller.delete

alipay = require('./alipay_config').alipay;
alipay.route(router);

module.exports = router
