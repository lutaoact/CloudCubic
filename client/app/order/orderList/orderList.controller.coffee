'use strict'

angular.module('budweiserApp').controller 'OrderListCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
  notify
) ->

#  angular.extend $scope,

  Restangular.all('orders').getList()
  .then (orders)->
    $scope.orders = orders
    console.log orders
