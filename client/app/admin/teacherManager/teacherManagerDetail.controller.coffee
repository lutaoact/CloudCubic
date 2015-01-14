'use strict'

angular.module('budweiserApp')

.controller 'TeacherManagerDetailCtrl', (
  $state
  $scope
  chartUtils
  Restangular
) ->

  resetSelectedClasse = ->
    selectedClasse = _.find($scope.classes, _id:$scope.selectedClasse?._id) ? $scope.classes?[0]
    angular.extend $scope.selectedClasse, selectedClasse
    if selectedClasse?.students.length
      chartUtils.genStatsOnScope($scope, selectedClasse?.courseId?._id, selectedClasse._id)

  angular.extend $scope,
    $state: $state
    classes: null
    selectedClasse: {}

    updateTeacher: ->
      $scope.reloadTeachers()

    deleteTeacher: ->
      $scope.reloadTeachers()
      $state.go('admin.teacherManager')

  Restangular.one('users', $state.params.teacherId).get()
  .then (teacher) ->
    $scope.teacher = teacher

  Restangular.all('classes').getList({teacherId: $state.params.teacherId,from: 0, limit: 1000})
  .then (classes) ->
    $scope.classes = classes.sort (x,y)->
      x.students.length < y.students.length
    resetSelectedClasse()

  $scope.$watch 'selectedClasse._id', resetSelectedClasse

