'use strict'

angular.module('budweiserApp').controller 'SignupCtrl', (
  $scope
  webview
  $location
  Restangular
  $timeout
) ->

  $scope.webview = webview
  $scope.user = {}
  $scope.errors = {}
  $scope.organization = {}

  $scope.register = (form) ->

    $scope.submitted = true

    if form.$valid
      # Account created, redirect to home
      Restangular.all('register/user').post
        name: $scope.user.name
        email: $scope.user.email
        password: $scope.user.password
        username: $scope.user.email
      .then ->
        $location.path '/'
      , (err) ->
        err = err.data
        $scope.errors = {}

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

  $scope.registerOrg = (form) ->

    $scope.submitted = true

    if form.$valid
      # Account created, redirect to home
      Restangular.all('register/org').post
        name: $scope.organization.name + '的管理员'
        email: $scope.user.email
        password: $scope.user.password
        username: $scope.user.email
        orgName: $scope.organization.name
        orgUniqueName: $scope.organization.uniqueName
      .then ->
        $location.path '/'
      , (err) ->
        err = err.data
        $scope.errors = {}

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

  angular.extend $scope,
    promise = undefined
    checkEmail: (email)->
      $timeout.cancel(promise)
      if email.$modelValue
        promise = $timeout ->
          Restangular.one('users','check').get(email: email.$modelValue)
          .then (data)->
            email.$setValidity 'remote', true
          , (err)->
            email.$setValidity 'remote', false
        , 500

    checkPasswordAgain: (password, passwordAgain)->
      if passwordAgain.$modelValue
        if passwordAgain.$modelValue is password.$modelValue
          passwordAgain.$setValidity 'sameWith', true
        else
          passwordAgain.$setValidity 'sameWith', false
      else
        passwordAgain.$setValidity 'sameWith', true




