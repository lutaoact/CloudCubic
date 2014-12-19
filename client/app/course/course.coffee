'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'course',
    url: ''
    templateUrl: 'app/course/course.html'
    controller: 'CourseCtrl'
    resolve:
      Courses: (Restangular)->
        Restangular.all('courses/public').getList()
      CurrentUser: (Auth)->
        Auth.getCurrentUser()
    abstract: true
