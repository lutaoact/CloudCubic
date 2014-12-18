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
  body.outTradeNo = _u.buildTradeNo body.userId
  body.status = 'unpaid'
  Order.createQ body
  .then (order) ->
    res.send 201, order
  , next