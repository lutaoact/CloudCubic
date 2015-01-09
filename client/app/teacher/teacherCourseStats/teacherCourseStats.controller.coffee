'use strict'

angular.module('budweiserApp').controller 'TeacherCourseStatsCtrl', (
  $scope
  $state
  Navbar
  $window
  $timeout
  Restangular
) ->
  Restangular.one('courses', $state.params.courseId).get()
  .then (course)->
    $scope.course = course
    Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"

  Restangular.all('classes').getList courseId: $state.params.courseId
  .then (classes) ->
    $scope.classes = classes

  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,

    viewState: {}

    triggerResize: ()->
      # trigger to let the chart resize
      $timeout ->
        angular.element($window).resize()

    viewStudentStats: (student)->
      $state.go 'teacher.courseStats.student',
        courseId: $scope.course._id
        classeId: student.$classeInfo.id
        studentId: student._id or student

    viewClasseStats: (classe)->
      $scope.viewState.classe = classe
      $state.go 'teacher.courseStats.classe',
        courseId: $scope.course._id
        classeId: classe._id or classe

.controller 'TeacherCourseStatsMainCtrl', (
  $scope
  $state
  chartUtils
) ->
  $scope.viewState.student = undefined
  $scope.viewState.classe = undefined

  chartUtils.genStatsOnScope $scope, $state.params.courseId

.controller 'TeacherCourseStatsStudentCtrl', (
  $scope
  $state
  chartUtils
) ->

  chartUtils.genStatsOnScope $scope, $state.params.courseId, $state.params.classeId, $state.params.studentId

.controller 'TeacherCourseStatsClasseCtrl', (
  $scope
  $state
  chartUtils
) ->

  chartUtils.genStatsOnScope $scope, $state.params.courseId, $state.params.classeId


