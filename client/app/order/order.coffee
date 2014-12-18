'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'order',
    url: '/order/:orderId'
    templateUrl: 'app/order/order.html'
    controller: 'OrderCtrl'
    navClasses: 'home-nav'
