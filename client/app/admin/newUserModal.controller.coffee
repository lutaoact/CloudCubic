'use strict'

angular.module('budweiserApp').controller 'NewUserModalCtrl', (
  $log
  $scope
  notify
  configs
  userRole
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    imageSizeLimitation: configs.imageSizeLimitation
    errors: null

    user:
      role: userRole
      email: ''

    title:
      switch userRole
        when 'student' then '添加学生'
        when 'teacher' then '添加老师'
        when 'admin'   then '添加管理员'
        else $log.error "unknown user.role #{userRole}"

    searchedUsers: []
    selectedUser: null

    selectUser: ($item, search, $event)->
      $scope.selectedUser = $item
      console.log $item, search, $event

    searchUsers: ($search)->
      if $search.search
        $scope.searchedUsers.length = 0
        Restangular.all('users/match').getList query: $search.search
        .then (users)->
          if users.length
            users.forEach (user)->
              $scope.searchedUsers.push
                text: user.name+' '+user.email
                user: anuglar.copy(user)
          else
            if /^[_a-z0-9-\+]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i.test $search.search
              $scope.searchedUsers.push
                text: '发送邀请给'+$search.search
                email: $search.search

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      $scope.submitted = true
      if !$scope.selectedUser
        form.user.$setValidity 'required', false
      if !form.$valid then return
      if $scope.selectedUser.user
        $modalInstance.close $scope.selectedUser.user
      else
        newUser = angular.copy $scope.user
        newUser.email = $scope.selectedUser.email
        Restangular.all('users').post newUser
        .then $modalInstance.close, (error) ->
          $scope.errors = error?.data?.errors

