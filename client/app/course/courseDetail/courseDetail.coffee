'use strict'

angular.module('budweiserApp').config ($urlRouterProvider, $stateProvider) ->
  $stateProvider
  .state 'course.detail',
    url: ''
    templateUrl: 'app/course/courseDetail/courseDetail.html'
    controller: 'CourseDetailCtrl'
  .state 'course.detail.desc',
    url: ''
    templateUrl: 'app/course/courseDetail/courseDetailDesc.html'
  .state 'course.detail.lectures',
    url: '/lectures'
    templateUrl: 'app/course/courseDetail/courseDetailLectures.html'
  .state 'course.detail.comments',
    url: '/comments'
    templateUrl: 'app/course/courseDetail/courseDetailComments.html'
