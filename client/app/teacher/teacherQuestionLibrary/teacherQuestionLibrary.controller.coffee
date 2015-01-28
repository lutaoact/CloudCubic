'use strict'

angular.module('budweiserApp').controller 'TeacherQuestionLibraryCtrl', (
  $scope
  $state
  KeyPoints
  Restangular
) ->

  angular.extend $scope,
    course: null
    keyPoints: KeyPoints

  Restangular
  .one('courses', $state.params.courseId)
  .get()
  .then (course) ->
    $scope.course = course
