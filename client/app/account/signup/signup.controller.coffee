'use strict'

angular.module('budweiserApp').controller 'SignupCtrl', (
  $scope
  $timeout
  Restangular
  mailAddressService
  notify
  $state
  org
  $localStorage
) ->

  Restangular.all('areas').getList().then (areas) ->
    $scope.cities = areas[0]

  angular.extend $scope,
    user: {}
    errors: {}
    submitted: false
    signupFinish: false
    emailAddress: null
    organization: {}
    checkEmailPromise: null
    isCloud3edu: !org
    file: $localStorage[$state.params.file] if $state.params.file

    registerOrg: (form) ->
      $scope.submitted = true
      if form.$valid
        # Account created, redirect to home
        Restangular.all('register/org').post
          name: $scope.user.email.replace(/@.*/,'')
          email: $scope.user.email
          password: $scope.user.password
          orgName: $scope.organization.name
          orgUniqueName: $scope.organization.uniqueName
          orgLocation: $scope.organization.location
        .then ->
          $scope.signupFinish = true
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
          , (err, status)->
            email.$setValidity 'remote', false
            email.$remoteChecked = false
        , 800

    checkPasswordAgain: (password, passwordAgain) ->
      passwordVal = password.$modelValue
      passwordAgainVal = passwordAgain.$modelValue
      passwordAgain.$setValidity 'sameWith', !passwordAgainVal || passwordAgainVal == passwordVal

    checkOrgUniqueNamePromise: undefined

    checkOrgUniqueName: (orgUniqueName)->
      $timeout.cancel($scope.checkOrgUniqueNamePromise)
      orgUniqueName.$remoteChecked = false
      orgUniqueName.$setValidity 'remote', true
      if orgUniqueName.$modelValue
        orgUniqueName.$remoteChecked = 'pending'
        orgUniqueName.$setValidity 'remote', true
        $scope.checkOrgUniqueNamePromise = $timeout ->
          Restangular.one('organizations','check').get(uniqueName: orgUniqueName.$modelValue)
          .then (data)->
            orgUniqueName.$setValidity 'remote', true
            orgUniqueName.$remoteChecked = true
          , (err, status)->
            orgUniqueName.$setValidity 'remote', false
            orgUniqueName.$remoteChecked = false
        , 800

    initEmailAddress: ->
      $scope.emailAddress = mailAddressService.getAddress($scope.user.email)

    cities: undefined

    register: (form) ->
      $scope.submitted = true
      if form.$valid
        # Account created, redirect to home
        Restangular.all('register/user').post
          name: $scope.user.email.split('@')[0]
          email: $scope.user.email
          password: $scope.user.password
        .then ->
          $scope.signupFinish = true
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

  if $scope.file
    $scope.user.email = $scope.file.email
    $scope.user.password = $scope.file.password

