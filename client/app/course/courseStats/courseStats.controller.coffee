'use strict'

angular.module('budweiserApp').controller 'CourseStatsCtrl', (
  Auth
  Navbar
  $state
  $scope
  Courses
  chartUtils
  $timeout
  $window
) ->

  course = _.find Courses, _id:$state.params.courseId

  Navbar.setTitle course.name, "course.detail({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  chartUtils.genStatsOnScope $scope, $state.params.courseId

  angular.extend $scope,
    student: Auth.getCurrentUser()

    triggerResize: ()->
      # trigger to let the chart resize
      $timeout ->
        angular.element($window).resize()
