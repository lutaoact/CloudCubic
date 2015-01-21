'use strict'

angular.module('budweiserApp').directive 'registerForm', ->
  templateUrl: 'app/directives/registerForm/registerForm.html'
  restrict: 'E'
  replace: true

  controller: (
    $scope
    $state
    notify
    $localStorage
  ) ->

    angular.extend $scope,
      user: {}

      register: (form) ->
        if !form.$valid then return
        if @user.passwordAgain isnt @user.password
          notify
            message: '两次输入密码不一致'
            classes: 'alert-danger'
          return
        if @user.password?.length < 6
          notify
            message: '密码至少6位'
            classes: 'alert-danger'
          return
        # Logged in, redirect to home
        code = getRandomStr(6)
        $localStorage[code] = $scope.user
        $state.go 'signup',
          file: code

