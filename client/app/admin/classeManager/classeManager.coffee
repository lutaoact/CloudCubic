'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider

  .state 'admin.classeManager',
    url: '/classes'
    templateUrl: 'app/admin/classeManager/classeManager.html'
    controller: 'ClasseManagerCtrl'
    roleRequired: 'admin'
    resolve:
      Classes: (Restangular) ->
        Restangular.all('classes').getList()
        .then (classes) ->
          classes
        .catch (error) ->
          console.debug 'get classes error', error
          []
      Courses: (Restangular) ->
        Restangular.all('courses').getList()

  .state 'admin.classeManager.detail',
    url: '/:classeId'
    templateUrl: 'app/admin/classeManager/classeManagerDetail.html'
    controller: 'ClasseManagerDetailCtrl'
    roleRequired: 'admin'

  .state 'admin.classeManager.detail.student',
    url: '/students/:studentId'
    templateUrl: 'app/admin/classeManager/classeManagerStudentDetail.html'
    controller: 'ClasseManagerStudentDetailCtrl'
    roleRequired: 'admin'
