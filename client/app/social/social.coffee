'use strict'

angular.module('budweiserApp')

.config (
  $stateProvider
  $urlRouterProvider
) ->

  $stateProvider

  .state 'social',
    url: '/social'
    templateUrl: 'app/social/social.html'
    controller: 'SocialCtrl'
    navClasses: 'home-nav'

.controller 'SocialCtrl', (
  $scope
  $cookieStore
)->
  angular.extend $scope,
    social: {}

