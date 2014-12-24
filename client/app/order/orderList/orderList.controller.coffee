'use strict'

angular.module('budweiserApp').controller 'OrderListCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
  notify
) ->

  angular.extend $scope,
    deleteOrder: (order)->
      order.remove()
      .then ->
        _.remove $scope.orders, (_order)->
          _order == order

  Restangular.all('orders').getList()
  .then (orders)->
    $scope.orders = orders
    console.log orders
