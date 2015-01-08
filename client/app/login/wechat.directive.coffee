angular.module 'budweiserApp'

.directive 'weixinLogin' , ->
  
  restrict : 'E'
  replace: true
  
  template : """<div id="weixin-login"></div>"""
  
  link : ->
    new WxLogin
      id    : 'weixin-login'
      appid : 'wx0b867034fb0d7f4e'
      scope : 'snsapi_login'
      state : 'STATE'
      style : 'black'
      redirect_uri: 'http://www.cloud3edu.com/auth/weixin/callback'
