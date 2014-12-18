'use strict'

angular.module('budweiserApp').controller 'OrderCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
  $location
) ->
  Restangular.all('orders').customGET($state.params.orderId)
  .then (order)->
    $scope.order = order

  angular.extend $scope,
    itemsPerPage: 10
    currentPage: 1

    pay: ()->
      Restangular.all('orders').customGET("#{$state.params.orderId}/pay")
      .then (data)->
        url = "https://mapi.alipay.com/gateway.do?" + $.param(data.plain())
        window.open url, "MsgWindow", "top=50, left=50, width=800, height=600"

