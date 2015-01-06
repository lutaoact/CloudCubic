'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'courseDetail',
    url: '/courses/:courseId/classes/:classeId'
    templateUrl: 'app/course/courseDetail/courseDetail.html'
    controller: 'CourseDetailCtrl'
