'use strict'

angular.module('budweiserApp').config (
  $stateProvider
) ->

  $stateProvider.state 'admin.orderManager',
    url: '/orders'
    templateUrl: 'app/admin/orderManager/orderManager.html'
    controller: 'orderManagerCtrl'
    roleRequired: 'admin'
