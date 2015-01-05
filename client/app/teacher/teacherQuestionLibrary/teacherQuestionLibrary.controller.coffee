'use strict'

angular.module('budweiserApp').controller 'TeacherQuestionLibraryCtrl', (
  $scope
  $state
  Navbar
  KeyPoints
  Restangular
) ->

  angular.extend $scope,
    course: null
    keyPoints: KeyPoints

  $scope.$on '$destroy', Navbar.resetTitle

  Restangular
  .one('courses', $state.params.courseId)
  .get()
  .then (course) ->
    $scope.course = course
    Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
    console.log course
