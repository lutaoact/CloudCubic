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

  .state 'forgot',
    url: '/forgot'
    templateUrl: 'app/account/forgot/forgot.html'
    controller: 'ForgotCtrl'

  .state 'reset',
    url: '/reset?email&token'
    templateUrl: 'app/account/reset/reset.html'
    controller: 'ResetCtrl'

  .state 'settings',
    abstract: true
    url: '/settings'
    templateUrl: 'app/account/settings/settings.html'
    controller: 'SettingsCtrl'

  .state 'settings.profile',
    url: '/profile'
    templateUrl: 'app/account/profile/profile.html'
    controller: 'ProfileCtrl'
    roleRequired: 'user'

  .state 'settings.notice',
    url: '/notice?page'
    templateUrl: 'app/account/notice/notice.html'
    controller: 'NoticeCtrl'
    roleRequired: 'user'

  .state 'settings.broadcast',
    url: '/broadcast'
    templateUrl: 'app/account/broadcast/broadcast.html'
    controller: 'BroadcastCtrl'
    roleRequired: 'user'