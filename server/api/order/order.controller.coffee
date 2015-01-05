"use strict"

Order = _u.getModel "order"
Classe = _u.getModel "classe"
Cart = _u.getModel "cart"
populateClasses = require '../../utils/populateClasses'
OrgAlipay = _u.getModel "org_alipay"

alipay = require('./alipay_config').alipay;

alipay
.on 'verify_fail', ()->
  console.log('emit verify_fail')
.on 'create_direct_pay_by_user_trade_finished', (out_trade_no, trade_no)->
  console.log('create_direct_pay_by_user_trade_finished')
.on 'create_direct_pay_by_user_trade_success', (out_trade_no, trade_no)->
  # TODO: validate previous unpaid orders
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
    Cart.clearByUserId(order.userId)
    console.log 'added to class'
  .fail (error)->
    console.log error
  .done()


exports.index = (req, res, next)->
  if req.user.role == 'admin'
    conditions = orgId: req.org._id
  else
    conditions = userId: req.user._id
  conditions.status = req.query.status if req.query.status

  limit = req.query.limit ? Const.PageSize['Order']
  from = req.query.from ? 0

  ordersPromise = Order.find conditions
  ordersPromise = ordersPromise.populate "userId", "name email" if req.user.role == 'admin'
  ordersPromise = ordersPromise
  .sort {created: -1}
  .limit limit
  .skip from
  .execQ()
  .then (orders) ->
    Q.all(_.map orders, (order)->
      populateClasses order
    )

  Q.all [
    ordersPromise
    Order.countQ conditions
  ]
  .spread (orders, count) ->
    return res.send
      results: orders
      count: count
  , next


exports.create = (req, res, next)->
  body = req.body
  body.userId = req.user._id
  body.status = 'unpaid'
  body.orgId = req.org._id

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
    populateClasses order
  .then (order) ->
    res.send order
  , next


exports.pay = (req, res, next)->
  orderId = req.params.id
  userId = req.user._id
  order = null

  Order.findOneQ
    _id: orderId
    userId: userId
  .then (result) ->
    order = result
    Classe.getAllStudents order.classes
  .then (students)->
    if _u.contains students, userId
      order.status = 'invalid'
      order.saveQ()
      .then ->
        return Q.reject
          status: 403
          errCode: ErrCode.ClassAlreadyPaid
          errMsg: '该订单已包含已付款课程'
  .then ->
    OrgAlipay.findByOrgIdLean req.org._id
  .then (org_alipay)->
    data =
      out_trade_no: order._id
      subject: '课程订单'
      total_fee: order.totalFee
      body: '课程订单'
      show_url: req.protocol+'://'+req.headers.host+'/orders/'+orderId

    org_alipay.host = req.protocol+'://'+req.headers.host+'/api/orders'
    alipay.set_org_conf org_alipay

    alipay.create_direct_pay_by_user(req.org._id, data, res);
  , next


exports.delete = (req, res, next)->
  orderId = req.params.id
  userId = req.user._id

  Order.findOneAndRemoveQ
    _id: orderId
    userId: userId
    status:
      $ne: "succeed"
  .then ->
    res.send 204
  .fail next
  .done()


exports.count = (req, res, next)->
  userId = req.user._id
  Q.all [
    Order.countQ {userId: userId}
    Order.countQ {userId: userId, status: 'unpaid'}
  ]
  .spread (totalCount, unpaidCount) ->
    res.send
      totalCount: totalCount
      unpaidCount: unpaidCount
  .fail next
  .done()