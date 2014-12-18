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
  order = null
  Order.findOneQ _id: out_trade_no
  .then (result)->
    order = result
    order.status = 'succeed'
    order.tradeNo = trade_no
    order.saveQ()
  .then ()->
    Q.all _.map order.classes, (classe)->
      Classe.getOneById classe
  .then (classes)->
    Q.all _.map classes, (classe)->
      classe.students.addToSet order.userId
      classe.saveQ()
  .then ()->
    console.log 'added to class'
  .fail (error)->
    console.log error
  .done()


exports.index = (req, res, next)->
  userId = req.user._id
  Order.findQ  userId: userId
  .then (orders) ->
    return res.send orders
  , next


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

    alipay.create_direct_pay_by_user(data, res);
  , next