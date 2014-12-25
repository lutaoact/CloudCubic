angular.module('budweiserApp').directive 'orderDetail', ->
  templateUrl: 'app/directives/orderDetail/orderDetail.html'
  restrict: 'EA'
  replace: true
  scope:
    order: '='
    onOrderDeleted: '&'
  controller: (
    $scope,
    $state,
    notify,
    $rootScope,
    Restangular
  )->
    angular.extend $scope,
      pay: ()->
        Restangular.all('orders').customGET("#{$scope.order._id}/pay")
        .then (data)->
          url = "https://mapi.alipay.com/gateway.do?" + $.param(data.plain())
          window.open url, "MsgWindow", "top=50, left=50, width=800, height=600"
        .catch (err)->
          console.log err
          if err.data.errCode = '10017'
            notify
              message: "该订单已实效"
              classes: 'alert-failed'
              duration: 2000

      deleteOrder: (order)->
        order.remove()
        .then ->
          $scope.onOrderDeleted()?(order)