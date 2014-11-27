'use strict'

angular.module('budweiserApp').directive 'loginForm', ->
  templateUrl: 'app/directives/loginForm/loginForm.html'
  restrict: 'E'
  replace: true

  controller: (
    Msg
    Auth
    $modal
    $scope
    $state
    notify
    $location
    socketHandler
    $localStorage
    loginRedirector
    $http
    $timeout
  ) ->

    $localStorage.global ?= {}
    $localStorage.global.loginState = $state.current.name
    $localStorage.global.loginPath = $state.current.url

    angular.extend $scope,
      user: {}
      errors: {}

      login: (form) ->
        $scope.loggingIn = true
        if !form.$valid then return
        # Logged in, redirect to home
        Auth.login(
          email: $scope.user.email
          password: $scope.user.password
        ).then ->
          Auth.getCurrentUser().$promise.then (me)->
            $scope.loggingIn = false
            $scope.$emit 'loginSuccess', me
        , (error)->
          console.debug error
          $scope.loggingIn = false

          if error.unactivated
            $modal.open
              templateUrl: 'app/directives/loginForm/activateModal.html'
              controller: 'ActivateModalCtrl'
              windowClass: 'center-modal'
              size: 'sm'
              resolve:
                email: -> $scope.user.email
            .result.then () ->
              notify
                message: "一封激活邮件即将发送到'#{$scope.user.email}'，请注意查收。"
                classes: 'alert-success'
                duration: 10000

          else
            notify
              message:'用户名或密码错误'
              classes:'alert-danger'

      weiboLogin: ()->
        $timeout ->
          weiboLoginWindow = window.open("/auth/weibo", "_self", "toolbar=yes, scrollbars=yes, resizable=yes, top=500, left=500, width=400, height=400")



