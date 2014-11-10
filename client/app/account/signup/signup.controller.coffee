'use strict'

angular.module('budweiserApp').controller 'SignupCtrl', (
  $scope
  webview
  $location
  Restangular
  $timeout
  $http
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
        orgLocation: $scope.organization.location
      .then ->
        $location.path '/'
      , (err) ->
        err = err.data
        $scope.errors = {}
        notify
          message: '创建失败'
          classes: 'alert-danger'

        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message
  $http.get('api/areas')
  .success (areas)->
    $scope.cities = areas[0]

  angular.extend $scope,
    checkEmailPromise: undefined

    checkEmail: (email)->
      $timeout.cancel($scope.checkEmailPromise)
      if email.$modelValue
        email.$remoteChecked = 'pending'
        email.$setValidity 'remote', true
        $scope.checkEmailPromise = $timeout ->
          Restangular.one('users','check').get(email: email.$modelValue)
          .then (data)->
            email.$setValidity 'remote', true
            email.$remoteChecked = true
          , (err)->
            email.$setValidity 'remote', false
            email.$remoteChecked = false
        , 800

    checkPasswordAgain: (password, passwordAgain)->
      if passwordAgain.$modelValue
        if passwordAgain.$modelValue is password.$modelValue
          passwordAgain.$setValidity 'sameWith', true
        else
          passwordAgain.$setValidity 'sameWith', false
      else
        passwordAgain.$setValidity 'sameWith', true

    checkOrgUniqueNamePromise: undefined

    checkOrgUniqueName: (orgUniqueName)->
      $timeout.cancel($scope.checkOrgUniqueNamePromise)
      if orgUniqueName.$modelValue
        orgUniqueName.$remoteChecked = 'pending'
        orgUniqueName.$setValidity 'remote', true
        $scope.checkOrgUniqueNamePromise = $timeout ->
          Restangular.one('organizations','check').get(uniqueName: orgUniqueName.$modelValue)
          .then (data)->
            orgUniqueName.$setValidity 'remote', true
            orgUniqueName.$remoteChecked = true
          , (err)->
            orgUniqueName.$setValidity 'remote', false
            orgUniqueName.$remoteChecked = false
        , 800

    cities: undefined





