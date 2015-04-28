'use strict'

angular.module('budweiserApp').controller 'CourseStatsCtrl', (
  Auth
  $state
  $scope
  $window
  $timeout
  chartUtils
  Restangular
  notify
  $q
) ->

  $q.all [
    Auth.getCurrentUser()
    $scope.classeQ
  ]
  .then (results) ->
    if results[0]._id not in results[1].students
      notify
        message: '您未加入班级，没有统计'
        classes: 'alert-warning'
      $timeout ()->
        $window.history.back()
      , 500
    else
      chartUtils.genStatsOnScope $scope, $state.params.courseId, $state.params.classeId

      angular.extend $scope,
        student: Auth.getCurrentUser()

        triggerResize: ()->
          # trigger to let the chart resize
          $timeout ->
            angular.element($window).resize()
