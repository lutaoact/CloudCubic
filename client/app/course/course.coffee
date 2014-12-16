'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'course',
    url: '/course/:courseId'
    templateUrl: 'app/course/course.html'
    controller: 'CourseCtrl'
    navClasses: 'home-nav'
    resolve:
      Courses: (Restangular)->
        Restangular.all('courses/public').getList()
