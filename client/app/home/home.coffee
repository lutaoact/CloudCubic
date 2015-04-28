'use strict'

angular.module('budweiserApp')
  .config ($stateProvider) ->
    $stateProvider
    .state 'home',
      url: '/home'
      templateUrl: 'app/home/home.html'
      controller: 'HomeCtrl'
