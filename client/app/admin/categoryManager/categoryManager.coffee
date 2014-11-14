'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider

  .state 'admin.categoryManager',
    url: '/categories'
    templateUrl: 'app/admin/categoryManager/categoryManager.html'
    controller: 'CategoryManagerCtrl'
    roleRequired: 'admin'
    resolve:
      Categories: (Restangular) ->
        Restangular.all('categories').getList().then (categories) ->
          categories
        , -> []

  .state 'admin.categoryManager.detail',
    url: '/:categoryId'
    templateUrl: 'app/admin/categoryManager/categoryManagerDetail.html'
    controller: 'CategoryManagerDetailCtrl'
    roleRequired: 'admin'

  .state 'admin.categoryManager.detail.course',
    url: '/courses/:courseId'
    templateUrl: 'app/admin/categoryManager/categoryManagerCourseDetail.html'
    controller: 'CategoryManagerCourseDetailCtrl'
    roleRequired: 'admin'

