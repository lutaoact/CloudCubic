'use strict'

angular.module('budweiserApp').factory 'Auth', (
  $q
  User
  $http
  $rootScope
  Restangular
  ipCookie
) ->

  currentUser =
    if ipCookie('token') then User.get() else {}

  ###
  Authenticate user and save token

  @param  {Object}   user     - login info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  login: (user, callback) ->
    cb = callback or angular.noop
    deferred = $q.defer()
    $http.post('/auth/local', user).success ((data) ->
      if data.targetUrl
        window.location.href = data.targetUrl
        return
      currentUser = User.get() # reset User cookie is set by server in response header
      deferred.resolve currentUser
      cb()
    ).bind(@)
    .error ((err) ->
      @logout()
      deferred.reject err
      cb err
    ).bind(@)
    deferred.promise

  ###
  Delete access token and user info

  @param  {Function}
  ###
  logout: ->
    ipCookie.remove 'token'
    currentUser = {}
    Tinycon.reset()
    $rootScope.$emit 'logoutSuccess'
    return

  ###
  Gets all available info on authenticated user

  @return {Object} user
  ###
  getCurrentUser: ->
    currentUser

  ###
  Check if a user is logged in

  @return {Boolean}
  ###
  isLoggedIn: ->
    #To support pasted url navigation
    currentUser.hasOwnProperty('role')

  ###
  Checks if the user role meets the minimum requirements of the route

  @return {Boolean}
  ###
  hasRole: (roleRequired, role) ->
    userRoles = [
      'user'      # 允许登录后的用户 abstract
      'student'   # 允许学生或以上
      'teacher'   # 允许老师或以上
      'admin'     # 允许管理员或以上
      'superuser' # 允许超级用户
    ]
    userRoles.indexOf(currentUser.role ? role) >= userRoles.indexOf(roleRequired)

  userRole : ->
    currentUser.role

  ###
  Get auth token
  ###
  getToken: ->
    ipCookie 'token'
