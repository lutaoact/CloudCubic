'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'course',
    url: '/courses/:courseId/classes/:classeId'
    templateUrl: 'app/course/course/course.html'
    controller: 'CourseCtrl'
    abstract: true
