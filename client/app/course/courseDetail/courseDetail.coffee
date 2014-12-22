'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'courseDetail',
    url: '/courses/:courseId'
    templateUrl: 'app/course/courseDetail/courseDetail.html'
    controller: 'CourseDetailCtrl'
