require '../server/common/init'

WechatUtils = _u.getUtils 'wechat'
menu =
  button: [
    type: 'view'
    name: '学院首页'
    url: 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx6c0c7d8c77eb802e&redirect_uri=http%3A%2F%2Fcloud3edu.cloud3edu.cn%2Fauth%2Fweixin_userinfo%2Fcallback&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect'
  ]

WechatUtils.createMenuQ 'cloud3edu.cloud3edu.cn', 'wx6c0c7d8c77eb802e', '66ed5e76107a0a289c422eda02e2b45e', menu
.then (result) ->
  console.log 'ok'
, (err) ->
  console.log err
