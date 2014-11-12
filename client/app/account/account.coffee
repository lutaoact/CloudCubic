'use strict'

angular.module('budweiserApp')

.config (
  $stateProvider
  $urlRouterProvider
) ->

  $urlRouterProvider.when('/settings','/settings/profile')

  $stateProvider

  .state 'signup',
    url: '/signup'
    templateUrl: 'app/account/signup/signup.html'
    controller: 'SignupCtrl'
    navClasses: 'home-nav'

  .state 'forgot',
    url: '/forgot'
    templateUrl: 'app/account/forgot/forgot.html'
    controller: 'ForgotCtrl'
    navClasses: 'home-nav'

  .state 'reset',
    url: '/reset?email&token'
    templateUrl: 'app/account/reset/reset.html'
    controller: 'ResetCtrl'
    navClasses: 'home-nav'

  .state 'settings',
    abstract: true
    url: '/settings'
    templateUrl: 'app/account/settings/settings.html'
    controller: 'SettingsCtrl'

  .state 'settings.profile',
    url: '/profile'
    templateUrl: 'app/account/profile/profile.html'
    controller: 'ProfileCtrl'
    authenticate: true

  .state 'settings.notice',
    url: '/notice'
    templateUrl: 'app/account/notice/notice.html'
    controller: 'NoticeCtrl'
    authenticate: true
