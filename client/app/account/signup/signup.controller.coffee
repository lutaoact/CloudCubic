'use strict'

angular.module('budweiserApp').controller 'SignupCtrl', (
  $scope
  webview
  $location
  Restangular
) ->

  $scope.webview = webview
  $scope.user = {}
  $scope.errors = {}
  $scope.organization = {}

  $scope.register = (form) ->

    $scope.submitted = true

    if form.$valid
      # Account created, redirect to home
      Restangular.all('users').post
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
      Restangular.all('users').post
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
