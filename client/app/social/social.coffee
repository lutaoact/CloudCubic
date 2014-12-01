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
  Restangular
  $q
)->

  weiboProfile = $cookieStore.get 'weibo_profile'
  qqProfile = $cookieStore.get 'qq_profile'

  angular.extend $scope,
    socials: []

    socialBind: (form)->
      if !form.$valid then return
      $scope.loading = true
      Auth.login(
        email: $scope.user.email
        password: $scope.user.password
      ).then ->
        promises = $scope.socials.map (social)->
          switch social.type
            when '微博'
              subUrl = 'weibo'
            when 'QQ'
              subUrl = 'qq'
          Restangular.all("bind/#{subUrl}").post social.params
        $q.all promises
        .then ->
          Auth.getCurrentUser().$promise.then (me)->
            $scope.loading = false
            $scope.$emit 'loginSuccess', me

  if weiboProfile
    $scope.socials.push
      type : '微博'
      name : utf8.decode weiboProfile.weibo_name
      params : weiboProfile
  if qqProfile
    $scope.socials.push
      type : 'QQ'
      name : utf8.decode qqProfile.qq_name
      params: qqProfile

