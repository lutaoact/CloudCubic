'use strict'

angular.module('budweiserApp')
  .config ($stateProvider) ->
    $stateProvider
    .state 'main',
      url: '/'
      templateUrl: 'app/main/main.html'
      controller: 'MainCtrl'
    .state 'main-home',
      url: '/home'
      templateUrl: 'app/main/org/main-home.html'
      controller: 'OrgMainCtrl'
