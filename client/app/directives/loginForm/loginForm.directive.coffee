'use strict'

angular.module('budweiserApp').directive 'loginForm', ->
  templateUrl: 'app/directives/loginForm/loginForm.html'
  restrict: 'E'
  replace: true

  controller: (
    org
    Msg
    Auth
    $http
    $modal
    $scope
    $state
    notify
    $timeout
    $location
    socketHandler
    $localStorage
    loginRedirector
  ) ->

    $localStorage.global ?= {}
    $localStorage.global.loginState = $state.current.name
    $localStorage.global.loginPath = $state.current.url

    angular.extend $scope,
      org: org
      user: {}
      loginUsers: null

      loginAgain: ->
        $scope.loginUsers = null

      login: (form, selectedOrgId) ->
        if !form.$valid then return
        $scope.loginUsers = null
        $scope.loggingIn = true
        # Logged in, redirect to home
        Auth.login(
          orgId: selectedOrgId
          email: $scope.user.email
          password: $scope.user.password
        ).then ->
          Auth.getCurrentUser().$promise.then (me)->
            $scope.loggingIn = false
            $scope.$emit 'loginSuccess', me
        .catch (error) ->
          console.debug error
          $scope.loggingIn = false

          if error.loginUsers
            $scope.loginUsers = error.loginUsers
            console.log 'login users', error.loginUsers
            return

          if error.unactivated
            $modal.open
              templateUrl: 'app/directives/loginForm/activateModal.html'
              controller: 'ActivateModalCtrl'
              windowClass: 'center-modal'
              size: 'sm'
              resolve:
                email: -> $scope.user.email
                orgId: -> selectedOrgId
            .result.then () ->
              notify
                message: "一封激活邮件即将发送到'#{$scope.user.email}'，请注意查收。"
                classes: 'alert-success'
                duration: 10000
            return

          notify
            message:'用户名或密码错误'
            classes:'alert-danger'

      weiboLogin: ()->
        $timeout ->
          weiboLoginWindow = window.open("/auth/weibo", "_self", "toolbar=yes, scrollbars=yes, resizable=yes, top=500, left=500, width=400, height=400")

      qqLogin: ()->
        $timeout ->
          weiboLoginWindow = window.open("/auth/qq", "_self", "toolbar=yes, scrollbars=yes, resizable=yes, top=500, left=500, width=400, height=400")
