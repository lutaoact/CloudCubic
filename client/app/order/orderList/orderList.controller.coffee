'use strict'

angular.module('budweiserApp').controller 'OrderListCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
) ->

  angular.extend $scope,
    status       : null
    maxSize      : 5
    currentPage  : 1
    itemsPerPage : 6

    changeStatus : (status)->
      $scope.status = status

    orderDeleted : (order)->
      _.remove $scope.orders, (_order)->
        _order == order

  $scope.$watchCollection '[status, currentPage]', ->
    Restangular.all('orders').getList(
      from        : ($scope.currentPage - 1) * $scope.itemsPerPage
      limit       : $scope.itemsPerPage
      status      : $scope.status
    )
    .then (orders)->
      $scope.orders = orders
