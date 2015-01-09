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

  chartUtils.genStatsOnScope $scope, $state.params.courseId

  angular.extend $scope,
    student: Auth.getCurrentUser()

    triggerResize: ()->
      # trigger to let the chart resize
      $timeout ->
        angular.element($window).resize()
