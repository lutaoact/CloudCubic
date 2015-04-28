'use strict'

angular.module('budweiserApp').config (
  $stateProvider
) ->

  $stateProvider.state 'admin.orgManager',
    url: '/organization'
    templateUrl: 'app/admin/organizationManager/organizationManager.html'
    controller: 'OrganizationManagerCtrl'
    roleRequired: 'admin'
