'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'orderList',
    url: '/orders'
    templateUrl: 'app/order/orderList/orderList.html'
    controller: 'OrderListCtrl'
    navClasses: 'home-nav'
