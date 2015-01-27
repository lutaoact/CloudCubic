angular.module('budweiserApp').directive 'orderDetail', ->
  templateUrl: 'app/directives/orderDetail/orderDetail.html'
  restrict: 'EA'
  replace: true
  scope:
    order: '='
    onOrderDeleted: '&'
  controller: (
    Auth
    $scope
    $state
    notify
    $modal
    $rootScope
    Restangular
  )->
    angular.extend $scope,
      Auth: Auth
      isCollapsed: false
      payUrl: null
      pay: ()->
        payWindow = window.open $scope.payUrl
        $modal.open
          templateUrl: 'app/directives/orderDetail/paymentConfirmModal.html'
          controller: 'PaymentConfirmModalCtrl'
          windowClass: 'center-modal'
          size: 'sm'
          resolve:
            order: -> $scope.order
            payWindow: -> payWindow

      deleteOrder: (order)->
        order.remove()
        .then ->
          $scope.onOrderDeleted()?(order)


    $scope.isCollapsed = (Auth.getCurrentUser().role == 'admin')

    $scope.$watch 'order', ->
      return if !$scope.order

      for i in [0 .. $scope.order.classes.length-1]
        $scope.order.classes[i].$orderPrice = $scope.order.prices[i]

      if $scope.order.status == 'unpaid' && Auth.getCurrentUser().role != 'admin'
        Restangular.all('orders').customGET("#{$scope.order._id}/pay")
        .then (data)->
          $scope.payUrl = "https://mapi.alipay.com/gateway.do?" + $.param(data.plain())
        .catch (err)->
          console.log err
          if err.data?.errCode == '10017'
            notify
              message: "该订单已失效"
              classes: 'alert-failed'
              duration: 2000
