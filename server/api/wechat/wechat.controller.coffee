'use strict'

wechat = require 'wechat'
Wechat = _u.getModel 'wechat'

exports.save = wechat(config.wechatToken, (req, res, next) ->
  data = content: req.weixin
  Wechat.createQ data
  .then (weixin) ->
    res.reply '消息已收到，多谢反馈'
  .catch next
  .done()
)
