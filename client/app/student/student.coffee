'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'student',
    url: '/s'
    templateUrl: 'app/student/student.html'
    controller: 'StudentCtrl'
    resolve:
      Courses: (Restangular)->
        Restangular.all('courses/public').getList()
      CurrentUser: (Auth)->
        Auth.getCurrentUser()
    abstract: true
