'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider

  .state 'admin.classeManager',
    url: '/classes?keyword&page'
    templateUrl: 'app/admin/classeManager/classeManager.html'
    controller: 'ClasseManagerCtrl'
    roleRequired: 'admin'
    resolve:
      #TODO 添加API：按照名字搜索对应的课程
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
