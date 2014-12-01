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
  $http
  Auth
)->

  weiboProfile = $cookieStore.get 'weibo_profile'
  qqProfile = $cookieStore.get 'qq_profile'

  angular.extend $scope,
    social: {}

    socialBind: (form)->
      if !form.$valid then return
      $scope.loading = true
      Auth.login(
        email: $scope.user.email
        password: $scope.user.password
      ).then ->
        if weiboProfile
          subUrl = 'weibo'
          params = weiboProfile
        else if qqProfile
          subUrl = 'qq'
          params = qqProfile

        $http.post "/bind/#{subUrl}", params
        .success ->
          Auth.getCurrentUser().$promise.then (me)->
            $scope.loading = false
            $scope.$emit 'loginSuccess', me

  if weiboProfile
    $scope.social.type = '微博'
    console.log weiboProfile
    $scope.social.name = weiboProfile.weibo_name
  else if qqProfile
    $scope.social.type = 'QQ'
    $scope.social.name = qqProfile.qq_name

