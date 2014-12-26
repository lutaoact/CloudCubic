'use scrict'

angular.module('budweiserApp').controller 'PaymentConfirmModalCtrl', (
  order
  $state
  $scope
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