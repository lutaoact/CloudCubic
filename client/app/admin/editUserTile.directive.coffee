'use strict'

angular.module('budweiserApp')

.directive 'editUserTile', ->
  restrict: 'EA'
  replace: true
  controller: 'EditUserTileCtrl'
  templateUrl: 'app/admin/editUserTile.html'
  scope:
    user: '='
    canDelete: '@' # 能否删除这个用户 - 管理员需要
    canRemark: '@' # 能否修改用户的备注信息 - 管理员需要
    onUpdateUser: '&'

.controller 'EditUserTileCtrl', (
  $state
  $scope
  $modal
  notify
  Restangular
  configs
  $log
) ->

  # 能被编辑的字段
  editableFields = [
    'name'
    'avatar'
    'info'
  ]

  angular.extend $scope,
    imageSizeLimitation: configs.imageSizeLimitation
    $state: $state
    errors: null
    editingInfo: null
    viewState:
      saved: true
      saving: false
      sending: false
    roleTitle: ''

    onAvatarUploaded: (key) ->
      $scope.editingInfo.avatar = key
      Restangular.one('users', $scope.user._id)
      .patch avatar: key
      .then ->
        $scope.user.avatar = key
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    sendActiveCode: ->
      $scope.viewState.sending = true
      Restangular.all('users').customPOST(email:$scope.user.email, 'sendActivationMail')
      .then ->
        notify
          message: "一封激活邮件即将发送到'#{$scope.user.email}'，请注意查收。"
          classes: 'alert-success'
          duration: 10000
      .finally ->
        $scope.viewState.sending = false

    saveProfile: (form) ->
      if !form.$valid then return
      $scope.viewState.saving = true
      $scope.errors = null
      Restangular.one('users', $scope.user._id)
      .patch($scope.editingInfo)
      .then ->
        $scope.viewState.saving = false
        angular.extend $scope.user, $scope.editingInfo
        notify
          message: '基本信息已保存'
          classes: 'alert-success'
        $scope.onUpdateUser?()
      .catch (error) ->
        $scope.viewState.saving = false
        $scope.errors = error?.data?.errors

  $scope.$watch 'user', (user) ->
    if !user? then return
    $scope.user = user
    $scope.editingInfo = _.pick user, editableFields
    $scope.roleTitle =
      switch user.role
        when 'student'   then '学生'
        when 'teacher'   then '教师'
        when 'admin'     then '管理员'
        when 'superuser' then '超级用户'
        else $log.error 'unknown user.role ' + user.role

  # 检查正在编辑的信息 是否 等于已经保存好的信息，并设置 viewState
  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.user, editableFields)
  , (isEqual) ->
    $scope.errors = null
    $scope.viewState.saved = isEqual
