'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'student',
    url: '/s'
    templateUrl: 'app/student/studentHome/studentHome.html'
    controller: 'StudentHomeCtrl'
    resolve:
      Courses: (Restangular)->
        Restangular.all('courses').getList().then (courses)->
          return courses
        , ->
          return []
      CurrentUser: (Auth)->
        Auth.getCurrentUser()
    abstract: true
