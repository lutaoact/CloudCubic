'use strict'

angular.module('budweiserApp').controller 'CourseStatsCtrl', (
  Auth
  $state
  $scope
  $window
  $timeout
  chartUtils
  Restangular
) ->

  chartUtils.genStatsOnScope $scope, $state.params.courseId, $state.params.classeId

  angular.extend $scope,
    student: Auth.getCurrentUser()

    triggerResize: ()->
      # trigger to let the chart resize
      $timeout ->
        angular.element($window).resize()
