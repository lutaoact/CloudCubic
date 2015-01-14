'use scrict'

angular.module('budweiserApp').controller 'PaymentConfirmModalCtrl', (
  order
  payWindow
  $state
  $scope
  $interval
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    order: order

    cancel: ->
      $modalInstance.dismiss('cancel')

    paySucceed: ->
      order.get()
      .then (data)->
        $scope.order.status = data.status
      $modalInstance.dismiss('cancel')

    payFailed: ->
      $state.go 'helpPayFailed'
      $modalInstance.dismiss('cancel')


  getOrderInterval = $interval ->
    if payWindow.closed
      $interval.cancel(getOrderInterval)
      return
    $scope.order.get()
    .then (data)->
      if data.status != 'unpaid'
        $scope.order.status = data.status
        payWindow?.close()
        $interval.cancel(getOrderInterval)
  , 1000

  $scope.$on '$destroy', ->
    $interval.cancel(getOrderInterval)