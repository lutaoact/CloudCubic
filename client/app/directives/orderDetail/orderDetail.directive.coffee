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
      pay: ()->
        Restangular.all('orders').customGET("#{$scope.order._id}/pay")
        .then (data)->
          $modal.open
            templateUrl: 'app/directives/orderDetail/paymentConfirmModal.html'
            controller: 'PaymentConfirmModalCtrl'
            windowClass: 'center-modal'
            size: 'sm'
            resolve:
              order: -> $scope.order
          url = "https://mapi.alipay.com/gateway.do?" + $.param(data.plain())
          window.open url
        .catch (err)->
          console.log err
          if err.data?.errCode == '10017'
            notify
              message: "该订单已实效"
              classes: 'alert-failed'
              duration: 2000

      deleteOrder: (order)->
        order.remove()
        .then ->
          $scope.onOrderDeleted()?(order)


    $scope.isCollapsed = (Auth.getCurrentUser().role == 'admin')