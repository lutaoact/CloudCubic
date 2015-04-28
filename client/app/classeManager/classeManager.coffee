'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider

  .state 'classeManager',
    url: '/classes?course&keyword&page'
    templateUrl: 'app/classeManager/classeManager.html'
    controller: 'ClasseManagerCtrl'
    roleRequired: 'teacher'

  .state 'classeManager.detail',
    url: '/:classeId'
    templateUrl: 'app/classeManager/classeManagerDetail.html'
    controller: 'ClasseManagerDetailCtrl'
    roleRequired: 'teacher'

  .state 'classeManager.detail.student',
    url: '/students/:studentId'
    templateUrl: 'app/classeManager/classeManagerStudentDetail.html'
    controller: 'ClasseManagerStudentDetailCtrl'
    roleRequired: 'teacher'
