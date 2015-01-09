'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'course.detail',
    url: ''
    templateUrl: 'app/course/courseDetail/courseDetail.html'
    controller: 'CourseDetailCtrl'
