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
        when 'student' then '添加新学生'
        when 'teacher' then '添加新老师'
        when 'admin'   then '添加新管理员'
        else $log.error "unknown user.role #{userRole}"

    cancel: ->
      $modalInstance.dismiss('cancel')

    onAvatarUploaded: (key) ->
      $scope.user.avatar = key

    confirm: (form) ->
      if !form.$valid then return
      newUser = angular.copy $scope.user
      Restangular.all('users').post newUser
      .then $modalInstance.close, (error) ->
        $scope.errors = error?.data?.errors

