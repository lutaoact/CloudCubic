angular.module 'budweiserApp'

.directive 'weixinLogin' , ($location) ->
  
  restrict : 'E'
  replace: true
  
  template : """<div id="weixin-login"></div>"""
  
  link : ->
    redirect = $location.absUrl()
    new WxLogin
      id    : 'weixin-login'
      appid : 'wx0b867034fb0d7f4e'
      scope : 'snsapi_login'
      state : 'STATE'
      style : 'black'
      #href  : 'https://www.cloud3edu.com/app/weixin.css' # weixin login css
      redirect_uri: 'http://www.cloud3edu.com/auth/weixin/callback?redirect='+redirect
