'use strict'

angular.module('budweiserApp')

.directive 'manageUsersList', ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/admin/manageUsersList.html'
  controller: 'ManageUsersListCtrl'

  scope:
    users: '='
    classe: '='
    classes: '='
    userRole: '@'
    onAddUser: '&'
    onRemoveUser: '&'
    onViewUser: '&'

.controller 'ManageUsersListCtrl', (
  $q
  $log
  Auth
  $scope
  $modal
  notify
  $filter
  fileUtils
  Restangular
  messageModal
  $rootScope
) ->

  updateSelected = ->
    $scope.selectedUsers =  _.filter($scope.users, '$selected':true)

  angular.extend $scope,
    Auth: Auth
    currentPage: 1
    pageSize: 10
    selectedUsers: []

    viewState:
      moving: false
      copying: false
      deleting: false
      importing: false

    roleTitle:
      switch $scope.userRole
        when 'student'   then '学生'
        when 'teacher'   then '教师'
        when 'admin'     then '管理员'
        when 'superuser' then '管理员'
        else $log.error 'unknown user.role ' + $scope.userRole

    addNewUser: ->
      $modal.open
        templateUrl: 'app/admin/newUserModal.html'
        controller: 'NewUserModalCtrl'
        windowClass: 'new-user-modal'
        resolve:
          userRole: -> $scope.userRole
          existingUsers : -> $scope.users
      .result.then (newUser) ->
        addNewUserSuccess = (newUser) ->
          notify
            message: "新#{$scope.roleTitle}添加成功"
            classes: 'alert-success'
          $scope.onAddUser?($data:newUser)

        if _.isEmpty($scope.classe?._id)
          addNewUserSuccess(newUser)
        else
          newUsers = _.union $scope.classe.students, [newUser._id]
          $scope.classe?.patch(students:newUsers).then ->
            addNewUserSuccess(newUser)

    showDetail: (user) ->
      $scope.onViewUser?($data:user)

    isSelectedAll: (currentUsers) ->
      _.filter(currentUsers, '$selected':true).length == currentUsers?.length

    toggleSelect: (users, selected, currentUsers) ->
      angular.forEach users, (u) -> u.$selected = selected
      updateSelected()

    removeUsers: (users) ->
      messageModal.open
        title: -> "删除#{$scope.roleTitle}"
        message: -> """确认要删除这#{users.length}个#{$scope.roleTitle}？"""
        buttons: ->
          if _.isEmpty($scope.classe?._id)
            [
              label: '取消', code: 'cancel', class: 'btn-default'
            ,
              label: '确认', code: 'ok',     class: 'btn-danger'
            ]
          else
            [
              label: '取消'       , code: 'cancel' , class: 'btn-default'
            ,
              label: '系统中删除' , code: 'ok'     , class: 'btn-danger'
            ,
              label: '该组中删除' , code: 'classe' , class: 'btn-danger'
            ]
      .result.then (code) ->
        $scope.toggledSelectAllUsers = false if $scope.toggledSelectAllUsers
        $scope.viewState.deleting = true
        (
          if code == 'ok'
            # 从系统中删除
            Restangular
            .all('users')
            .customPOST(ids: _.pluck(users, '_id'), 'multiDelete')
            .then (result) ->
              $rootScope.$broadcast "removeUsersFromSystem", result
          else
            # 从该组中移除
            newUsers = _.difference($scope.users, users)
            $scope.classe.patch(students: _.pluck newUsers, '_id')
        )
        .finally ->
          $scope.onRemoveUser?($data:users)
          $scope.viewState.deleting = false


    copyUsers: (users, targetClasse) ->
      $scope.viewState.copying = true
      # add users to target classe
      userIds = _.pluck(users, '_id')
      targetClasse.students = _.union targetClasse.students, userIds
      targetClasse.patch(students: targetClasse.students)
      .catch (error) ->
        notify
          message: "添加学生到 #{targetClasse.name} 出错了：#{error.data}"
          classes: 'alert-danger'
      .finally -> $scope.viewState.copying = false

    moveUsers: (users, targetClasse) ->
      $scope.viewState.moving = true
      # add users to target classe
      userIds = _.pluck(users, '_id')
      targetClasse.students = _.union targetClasse.students, userIds
      targetClasse.patch(students: targetClasse.students)
      .then ->
        if _.isEmpty($scope.classe._id)
          $scope.onRemoveUser?($data:users)
        else
          newUsers = _.difference($scope.users, users)
          $scope.classe.patch(students: _.pluck newUsers, '_id')
          .then -> $scope.onRemoveUser?($data:users)
      .catch (error) ->
        notify
          message: "分配学生到 #{targetClasse.name} 出错了：#{error.data}"
          classes: 'alert-danger'
      .finally -> $scope.viewState.moving = false


    importUsers: (files)->
      $scope.viewState.importing = true

      fail = (error) ->
        $scope.viewState.importing = false
        notify
          message: '批量导入失败 ' + error.data
          classes: 'alert-danger'

      success = (report) ->
        $scope.viewState.importing = false
        notify
          message: "新#{$scope.roleTitle}添加成功, 初始密码为登录邮箱。"
          classes: 'alert-success'
          duration: 0
        $scope.onAddUser?($data:report)

      fileUtils.uploadFile
        files: files
        validation:
          max: 50 * 1024 * 1024
          accept: 'excel'
        success: (key)->
          Restangular.all('users').customPOST
            key: key
            type: $scope.userRole
            classeId: $scope.classe?._id
          , 'bulk'
          .then success
          .catch fail
        fail: fail

  $scope.$watch 'users.length', updateSelected
