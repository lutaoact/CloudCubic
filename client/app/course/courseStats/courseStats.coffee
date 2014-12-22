'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'courseStats',
    url: '/courses/:courseId/stats'
    templateUrl: 'app/course/courseStats/courseStats.html'
    controller: 'CourseStatsCtrl'
