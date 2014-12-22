'use strict'

angular.module('budweiserApp').controller 'CourseStatsCtrl', (
  Auth
  Navbar
  $state
  $scope
  $window
  $timeout
  chartUtils
  Restangular
) ->

  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    Navbar.setTitle course.name, "courseDetail({courseId:'#{$state.params.courseId}'})"
    $scope.$on '$destroy', Navbar.resetTitle
    chartUtils.genStatsOnScope $scope, $state.params.courseId

  angular.extend $scope,
    student: Auth.getCurrentUser()

    triggerResize: ()->
      # trigger to let the chart resize
      $timeout ->
        angular.element($window).resize()
