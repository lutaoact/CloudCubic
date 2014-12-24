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
    status       : null
    maxSize      : 5
    currentPage  : 1
    itemsPerPage : 6
    deleteOrder  : (order)->
      order.remove()
      .then ->
        _.remove $scope.orders, (_order)->
          _order == order
    changeStatus : (status)->
      console.log status
      $scope.status = status

  $scope.$watchCollection '[status, currentPage]', ->
    Restangular.all('orders').getList(
      from        : ($scope.currentPage - 1) * $scope.itemsPerPage
      limit       : $scope.itemsPerPage
      status      : $scope.status
    )
    .then (orders)->
      $scope.orders = orders

  Restangular.all('orders').customGET('count')
  .then (data)->
    $scope.count = data