'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'admin.teacherManager',
    url: '/teachers'
    templateUrl: 'app/admin/teacherManager/teacherManager.html'
    controller: 'TeacherManagerCtrl'
    roleRequired: 'admin'

  .state 'admin.teacherManager.detail',
    url: '/:teacherId'
    templateUrl: 'app/admin/teacherManager/teacherManagerDetail.html'
    controller: 'TeacherManagerDetailCtrl'
    roleRequired: 'admin'
