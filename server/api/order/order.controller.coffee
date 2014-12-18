"use strict"

Order = _u.getModel "order"

alipay = require('./alipay_config').alipay;

alipay
.on 'verify_fail', ()->
  console.log('emit verify_fail')
.on 'create_direct_pay_by_user_trade_finished', (out_trade_no, trade_no)->
  console.log('create_direct_pay_by_user_trade_finished')
.on 'create_direct_pay_by_user_trade_success', (out_trade_no, trade_no)->
  console.log('create_direct_pay_by_user_trade_success')


exports.create_direct_pay_by_user = (req, res, next)->
  data =
    out_trade_no: 'asdf' # TODO: generate unique out_trade_no
    subject: req.query.subject
    total_fee: req.query.total_fee
    body: req.query.body
    show_url: req.query.show_url

  # TOD
  # req.query.classId

  alipay.create_direct_pay_by_user(data, res);

exports.create = (req, res, next)->
  body = req.body
  body.userId = req.user._id
  body.totalFee = 0.01
  body.status = 'unpaid'
  Order.createQ body
  .then (order) ->
    res.send 201, order
  , next


exports.show = (req, res, next) ->
  orderId = req.params.id
  Order.findOneQ
    _id: orderId
    userId: req.user._id
  .then (order) ->
    res.send order
  , next


exports.pay = (req, res, next)->
  orderId = req.params.id
  Order.findOneQ
    _id: orderId
    userId: req.user._id
  .then (order) ->
    data =
      out_trade_no: order._id
      subject: 'hehe'
      total_fee: order.totalFee
      body: 'hehe'
      show_url: 'http://abc.localhost:9000/'

    # TOD
    # req.query.classId

    alipay.create_direct_pay_by_user(data, res);