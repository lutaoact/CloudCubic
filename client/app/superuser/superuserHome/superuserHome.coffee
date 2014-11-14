'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'superuser.home',
    url: ''
    templateUrl: 'app/superuser/superuserHome/superuserHome.html'
    controller: 'SuperuserHomeCtrl'
    roleRequired: 'superuser'
    resolve:
      Organizations: (SuperuserAPI) ->
        SuperuserAPI.all('organizations').getList().then (organizations) ->
          organizations
        .catch (error) ->
          console.debug 'get organizations error', error
          []

  $stateProvider.state 'superuser.home.organization',
    url: '/organizations/:orgId'
    templateUrl: 'app/superuser/superuserHome/superuserOrgDetail.html'
    controller: 'SuperuserOrgDetailCtrl'
    roleRequired: 'superuser'
