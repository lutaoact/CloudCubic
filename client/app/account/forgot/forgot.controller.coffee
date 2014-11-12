'use strict'

angular.module('budweiserApp').controller 'ForgotCtrl', (
  $scope
  $state
  notify
  Restangular
) ->

  angular.extend $scope,
    email: ''
    viewState:
      sending: false
      sended: false

    sendVerifyEmail: (form) ->
      if !form.$valid then return
      $scope.viewState.sending = true
      Restangular.all('users').customPOST(email:$scope.email, 'forgotPassword')
      .then ->
        $scope.viewState.sended = true
        notify
          message: "一封找回密码邮件即将发送到'#{$scope.email}'，请注意查收。"
          classes: 'alert-success'
        $state.go 'main'
      .finally ->
        $scope.viewState.sending = false
