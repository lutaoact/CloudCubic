'use strict'

((console)->
  if /localhost/.test window.location.hostname
    console.remote = console.log
    return
  methods = ['log', 'error', 'remote']
  methods.map (method) ->
    oldFn = console[method]
    console[method] = (message)->
      if window.XMLHttpRequest
        xmlhttp = new XMLHttpRequest()
      else
        xmlhttp= new ActiveXObject("Microsoft.XMLHTTP")
      xmlhttp.open('POST',"/api/loggers",true)
      xmlhttp.setRequestHeader('Accept', '*')
      xmlhttp.setRequestHeader('Content-Type', 'application/json')
      try
        xmlhttp.send(JSON.stringify(_.values(arguments)))
      catch e
        xmlhttp.send(JSON.stringify(["error","JSON_convert",e?.toString()]))
      oldFn?.apply(console, arguments)
)(console)

((window)->
  preErrorHander = window.onerror
  window.onerror = (m, u, l)->
    preErrorHander?(m,u,l)
    console.remote 'error', 'onJSError', m, u, l
)(window)

angular.module 'budweiserApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngAnimate'
  'ngStorage'
  'ui.bootstrap'
  'ui.router'
  'ui.select'
  'com.2fdevs.videogular'
  'com.2fdevs.videogular.plugins.controls'
  'com.2fdevs.videogular.plugins.overlayplay'
  'com.2fdevs.videogular.plugins.buffering'
  'com.2fdevs.videogular.plugins.poster'
  'cgNotify'
  'duScroll'
  'restangular'
  'highcharts-ng'
  'angularFileUpload'
  'monospaced.elastic'
  'angular-sortable-view'
  'textAngular'
  'FBAngular'
  'ngPrettyJson'
  'ipCookie'
]

.constant 'configs',
  baseUrl: ''
  fpUrl: 'http://54.223.144.96:9090/'
  imageSizeLimitation    : 3 * 1024 * 1024
  fileSizeLimitation     : 128 * 1024 * 1024
  videoSizeLimitation    : 128 * 1024 * 1024
  proVideoSizeLimitation : 1024 * 1024 * 1024

.config ($provide) ->
  $provide.decorator "$exceptionHandler", ($delegate) ->
    (exception, cause)->
      $delegate(exception, cause)
      exception.cause = cause
      console.remote 'error','onAngularError', exception

.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/')
  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'
  $httpProvider.interceptors.push 'urlInterceptor'
  $httpProvider.interceptors.push 'patchInterceptor'
  $httpProvider.interceptors.push 'objectIdInterceptor'
  $httpProvider.interceptors.push 'loadingInterceptor'
  $httpProvider.interceptors.push 'errorHttpInterceptor'

.config ($compileProvider) ->
  $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|file|blob):|data:image\//)

.config (RestangularProvider) ->
  # add a response intereceptor
  RestangularProvider.setBaseUrl('api')
  RestangularProvider.setRestangularFields(id: "_id")
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    if operation is "getList" and data.results
      data.results.$count = data.count
      data.results
    else
      data

.factory 'urlInterceptor', ($rootScope, $q, $location, configs) ->
  # Add authorization token to headers
  request: (config) ->
    config.url = configs.baseUrl + config.url if /^(|\/)(api|auth)/.test config.url
    config

# Override patch to put
.factory 'patchInterceptor', ($location) ->
  request: (config) ->
    if config.method is 'PATCH'
      config.method = 'PUT'
    config

# Override patch to put
.factory 'objectIdInterceptor', ($location) ->
  request: (config) ->
    if config.data
      for own key, value of config.data
        if key.endsWith('Id') and value instanceof Object
          config.data[key] = value._id
    config

.factory 'loginRedirector', ($location, $localStorage) ->

  redirectKey = 'r'
  loginPath = $localStorage?.global?.loginPath or '/' #/login?r=xxx

  getRedirectUrl = ->
    redirect = $location.search()[redirectKey]
    if !redirect? then return undefined
    redirect

  set: (newRedirect) ->
    if getRedirectUrl()? || newRedirect is loginPath then return
    redirect = encodeURIComponent newRedirect
    $location.url "#{loginPath}?#{redirectKey}=#{redirect}"


  apply: ->
    if !getRedirectUrl()? then return false
    $location.url getRedirectUrl()
    $location.replace()
    true

.factory 'authInterceptor', ($rootScope, ipCookie, $q, $location, loginRedirector, initUser) ->
  # Add authorization token to headers
  request: (config) ->
    # When not withCredentials, should not carry Authorization header either
    if config.withCredentials is false
      return config
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + ipCookie('token') if ipCookie('token')
    config

  # Intercept 401s
  responseError: (response) ->
    if response.status is 401
      # todo: should clear initUser?
      # remove any stale tokens
      initUser = undefined
      ipCookie.remove 'token'

      $q.reject response
    else
      $q.reject response

.factory 'loadingInterceptor', ($rootScope, $q) ->
  # remain request numbers
  numLoadings = 0

  request: (config) ->
    numLoadings++
    $rootScope.$loading = true
    config

  response: (response)->
    if --numLoadings is 0
      # Hide loader
      $rootScope.$loading = false
    response or $q.when(response)

  responseError: (response) ->
    if --numLoadings is 0
      $rootScope.$loading = false
    $q.reject response

.factory 'errorHttpInterceptor', ($q) ->
  responseError: (response) ->
    if response.status isnt 401 # for privacy
      console.remote 'error', 'onHttpError', response
    $q.reject response

.service 'socketHandler', (
  socket
  $modal
  $rootScope
  Msg
) ->

  init: (me) ->
    socket.setup()
    if me?
      socket.setHandler Const.MsgType.Notice, (data) ->
#        $rootScope.$broadcast 'message.notice', data
        Msg.addMsg()
    if me?.role is 'student'
      socket.setHandler Const.MsgType.Quiz, (data) ->
        $modal.open
          templateUrl: 'app/teacher/teacherTeaching/receiveQuestion.html'
          controller: 'ReceiveQuestionCtrl'
          windowClass: 'pub-question-modal'
          backdrop: 'static'
          resolve:
            answer: -> data.answer
            question: -> data.question
            teacherId: -> data.teacherId

.run (
  Msg
  Auth
  $modal
  notify
  $state
  webview
  initUser
  $location
  initNotify
  $rootScope
  socketHandler
  PromiseCache
  loginRedirector
  org
) ->

  PromiseCache.refresh()

  $rootScope.webview = webview
  $rootScope.org = org
  $rootScope.getMe = Auth.getCurrentUser

  #set the default configuration options for angular-notify
  notify.config
    startTop: 30
    duration: 4000

  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
    if initUser? then return
    if !Auth.hasRole(toState.roleRequired)
      loginRedirector.set($state.href(toState, toParams))
      $modal.open
        templateUrl: 'app/login/loginModal.html'
        controller: 'loginModalCtrl'
        windowClass: 'login-window-modal'
        size: 'md'

  # fix bug, the view does not scroll to top when changing view.
  $rootScope.$on '$stateChangeSuccess', ->
    $("html, body").animate({ scrollTop: 0 }, 100)

  setupUser = (user) ->
    _hmt?.push(['_setCustomVar', 1, 'login', user._id, 3])
    Msg.init()
    socketHandler.init(user)
    if !loginRedirector.apply() && $state.current.name is 'main'
      homeState =
        if Auth.hasRole('admin') then 'admin.orgManager' else 'home'
      $state.go(homeState)

  # setup data & config for logged user
  $rootScope.$on 'loginSuccess', (event, user) ->
    setupUser(user)

  # Reload Auth
  Auth.getCurrentUser().$promise?.then setupUser

  # Display notify from server
  switch initNotify
    when 'activation-success'
      notify
        message: '恭喜，您的账户已经激活成功。'
        classes: 'alert-success'
        duration: 10000
    when 'activation-used'
      notify
        message: '抱歉，该邮箱激活码已经被使用过，请登录。'
        classes: 'alert-danger'
        duration: 10000
    when 'activation-none'
      notify
        message: '抱歉，该邮箱激活码非法或者已失效。'
        classes: 'alert-danger'
        duration: 10000
