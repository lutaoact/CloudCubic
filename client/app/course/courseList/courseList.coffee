'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'courseList',
    url: '/courses?category&keyword&page'
    templateUrl: 'app/course/courseList/courseList.html'
    controller: 'CourseListCtrl'
