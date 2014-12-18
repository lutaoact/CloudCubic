"use strict"

Order = _u.getModel "order"
Classe = _u.getModel "classe"

alipay = require('./alipay_config').alipay;

alipay
.on 'verify_fail', ()->
  console.log('emit verify_fail')
.on 'create_direct_pay_by_user_trade_finished', (out_trade_no, trade_no)->
  console.log('create_direct_pay_by_user_trade_finished')
.on 'create_direct_pay_by_user_trade_success', (out_trade_no, trade_no)->
  console.log('create_direct_pay_by_user_trade_success')


exports.create = (req, res, next)->
  body = req.body
  body.userId = req.user._id
  body.status = 'unpaid'

  Q.all _.map body.classes, (classe)->
    Classe.getOneById classe
  .then (classes)->
    body.totalFee = _.reduce classes, (sum, classe)->
      return sum + classe['price']
    , 0
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
      subject: '课程订单'
      total_fee: order.totalFee
      body: '课程订单'
      show_url: req.protocol+'://'+req.headers.host+'/order/'+orderId

    console.log data

    alipay.create_direct_pay_by_user(data, res);