'use strict'

angular.module('budweiserApp').controller 'SettingsCtrl', (
  Auth
  $scope
  $location
) ->

  angular.extend $scope,
    me: Auth.getCurrentUser()

    menu: [
      {
        title: '基本信息'
        link: 'settings/profile'
      }
      {
        title: '消息'
        link: 'settings/notice'
      }
    ]

    isActive: (route) ->
      _.str.trim(route, '/') is _.str.trim($location.path(), '/')
