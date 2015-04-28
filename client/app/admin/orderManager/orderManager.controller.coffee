'use strict'

angular.module('budweiserApp')

.controller 'orderManagerCtrl', (
  org
  notify
  $scope
  $state
  configs
  Restangular
) ->

  angular.extend $scope,
    maxSize      : 5
    currentPage  : 1
    itemsPerPage : 6
    search:
      status: null
      orderId: null

    orderDeleted : (order)->
      _.remove $scope.orders, (_order)->
        _order == order
      $scope.count.totalCount -= 1
      $scope.count.unpaidCount -= 1

    setKeyword: ->
      Restangular.one('orders', $scope.search.orderId).get()
      .then (order) ->
        $scope.orders = [order]
      .catch (err) ->
        $scope.orders = []
        notify
          message:'订单号不存在'
          classes:'alert-danger'

  $scope.$watchCollection '[search.status, currentPage]', ->
    Restangular.all('orders').getList(
      from        : ($scope.currentPage - 1) * $scope.itemsPerPage
      limit       : $scope.itemsPerPage
      status      : $scope.search.status
    )
    .then (orders)->
      $scope.orders = orders
