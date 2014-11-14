'use strict'

angular.module('budweiserApp').config (
  $stateProvider
) ->

  $stateProvider.state 'admin.home',
    url: '/organization'
    templateUrl: 'app/admin/organizationManager/organizationManager.html'
    controller: 'OrganizationManagerCtrl'
    roleRequired: 'admin'
