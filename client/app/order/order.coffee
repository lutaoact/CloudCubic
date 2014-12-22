'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'order',
    url: '/orders/:orderId'
    templateUrl: 'app/order/order.html'
    controller: 'OrderCtrl'
    navClasses: 'home-nav'
