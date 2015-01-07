angular.module 'budweiserApp'
.directive 'wechatLogin' , ->
  
  restrict : 'E'
  replace: true
  
  
  template : """<div id="wechat-login"></div>"""
  
  link : ->
    new WxLogin
      id: 'wechat-login'
      appid : 'wx0b867034fb0d7f4e'
      scope: 'snsapi_login'
      redirect_uri: 'http://www.cloud3edu.com'
      state: 'abcdefg'
      style: 'black'
