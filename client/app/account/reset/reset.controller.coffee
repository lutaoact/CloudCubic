'use strict'

angular.module('budweiserApp').controller 'ResetCtrl', (
  $scope
  $state
  notify
  Restangular
) ->

  console.debug $state.params

  angular.extend $scope,
    viewState:
      resetting: false
      reseted: false
    password: ''

    resetPassword: (form) ->
      if !form.$valid then return
      $scope.viewState.resetting = true
      data = angular.extend $state.params,
        password: $scope.password
      Restangular.all('users').customPOST(data, 'resetPassword')
      .then ->
        $scope.viewState.reseted = true
      .finally ->
        $scope.viewState.resetting = false

    checkPasswordAgain: (password, passwordAgain) ->
      console.debug 'checkPassword...', password, passwordAgain
      passwordVal = password.$modelValue
      passwordAgainVal = passwordAgain.$modelValue
      passwordAgain.$setValidity 'sameWith', !passwordAgainVal || passwordAgainVal == passwordVal
