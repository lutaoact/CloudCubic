'use strict'

angular.module('budweiserApp').controller 'OrderCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
  notify
) ->
  Restangular.all('orders').customGET($state.params.orderId)
  .then (order)->
    $scope.order = order
