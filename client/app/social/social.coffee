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

  weiboProfile = $cookieStore.get 'weibo_profile'

  if weiboProfile
    $scope.social.type = '微博'
    console.log weiboProfile

