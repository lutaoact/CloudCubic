'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'course.stats',
    url: '/stats'
    templateUrl: 'app/course/courseStats/courseStats.html'
    controller: 'CourseStatsCtrl'
