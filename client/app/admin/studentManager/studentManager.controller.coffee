'use strict'

angular.module('budweiserApp').controller 'StudentManagerCtrl', (
  $modal
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,
    students: null

    reloadStudents: ->
      Restangular.all('users').getList(role:'student')
      .then (students) ->
        $scope.students = students

    viewStudent: (student) ->
      $state.go('admin.studentManager.detail', studentId:student._id)

  $scope.reloadStudents()

