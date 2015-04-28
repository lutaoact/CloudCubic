'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'admin.studentManager',
    url: '/students'
    templateUrl: 'app/admin/studentManager/studentManager.html'
    controller: 'StudentManagerCtrl'
    roleRequired: 'admin'

  .state 'admin.studentManager.detail',
    url: '/:studentId'
    templateUrl: 'app/admin/studentManager/studentManagerDetail.html'
    controller: 'StudentManagerDetailCtrl'
    roleRequired: 'admin'
