'use strict'

angular.module('budweiserApp').controller 'LoginCtrl', (
  Auth
  socket
  $scope
  $window
  $location
  loginRedirector
) ->

  angular.extend $scope,
    user: {}
    errors: {}
    login: (form) ->
      $scope.submitted = true

      if form.$valid
        # Logged in, redirect to home
        Auth.login(
          email: $scope.user.email
          password: $scope.user.password
        ).then ->
          Auth.getCurrentUser().$promise.then (me)->
            socket.setup(me)
            if !loginRedirector.apply()
              if me.role is 'admin'
                $location.url('/admin')
              else if me.role is 'teacher'
                $location.url('/t')
              else if me.role is 'student'
                $location.url('/s')
              $location.replace()
        .catch (err) ->
          $scope.errors.other = err.message

    loginOauth: (provider) ->
      $window.location.href = '/auth/' + provider

    testLoginUsers: [
      name:'Student'
      email:'student@student.com'
      password: 'student'
    ,
      name:'Teacher'
      email:'teacher@teacher.com'
      password: 'teacher'
    ,
      name:'Admin'
      email:'admin@admin.com'
      password: 'admin'
    ]

    setLoginUser: ($event, form, user) ->
      $scope.user = user
      $scope.login(form) if $event.metaKey
