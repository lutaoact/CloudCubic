'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerDetailCtrl', (
  $scope
  $state
  notify
  $rootScope
) ->

  editableFields = [
    'name'
  ]

  angular.extend $scope,

    eidtingInfo: null
    saved: false

    saveClasse: (form) ->
      if !form.$valid  || $scope.saved then return
      $scope.selectedClasse.patch $scope.editingInfo
      .then (classe)->
        angular.extend $scope.selectedClasse, classe
        notify
          message: '班级名称修改成功'
          classes: 'alert-success'
      .catch (error) ->
        notify
          message: error?.data?.errors?.name?.message
          classes: 'alert-danger'

    reloadStudents: (users, remove) ->
      if _.isEmpty($scope.selectedClasse._id) || remove == 1
        $rootScope.$broadcast 'reloadStandAloneStudents'

      $scope.selectedClasse?.all?('students').getList()
      .then (students) ->
        $scope.selectedClasse.students = _.pluck students, '_id'
        $scope.selectedClasse.$students = students

    viewStudent: (student) ->
      $state.go('admin.classeManager.detail.student', classeId:$scope.selectedClasse._id, studentId:student._id)

  $scope.$parent.selectedClasse = _.find($scope.classes, _id:$state.params.classeId) ? $scope.other
  $scope.editingInfo = _.pick $scope.selectedClasse, editableFields
  $scope.reloadStudents()

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.selectedClasse, editableFields)
  , (isEqual) ->
    $scope.saved = isEqual
