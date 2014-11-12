'use strict'

angular.module('budweiserApp')
  .config ($stateProvider) ->
    $stateProvider
    .state('main',
      url: '/',
      templateUrl: 'app/main/main.html'
      controller: 'MainCtrl'
      navClasses: 'home-nav'
    )

.factory 'Page', ($document) ->
  # return
  setTitle: (newTitle) ->
    $document[0].title = newTitle
