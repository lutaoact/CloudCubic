'use strict'

User = _u.getModel 'user'

exports.bindWeibo = (req, res, next) ->
  user = req.user
  weibo =
    id   : req.body.weibo_id
    token: req.body.weibo_token
    name : req.body.weibo_name

  User.updateQ {_id: user._id}, {weibo: weibo}
  .then () ->
    res.send 200
  .catch next
  .done()


exports.bindQQ = (req, res, next) ->
  user = req.user
  qq =
    id   : req.body.qq_id
    token: req.body.qq_token
    name : req.body.qq_name

  User.updateQ {_id: user._id}, {qq: qq}
  .then () ->
    res.send 200
  .catch next
  .done()
