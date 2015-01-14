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
    $interval
  )->
    angular.extend $scope,
      Auth: Auth
      isCollapsed: false
      payWindow: null
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
          $scope.payWindow = window.open url

          getOrderInterval = $interval ->
            if $scope.payWindow.closed
              $interval.cancel(getOrderInterval)
              return
            console.log 'wtf'
            $scope.order.get()
            .then (data)->
              console.log data
              if data.status != 'unpaid'
                $scope.order.status = data.status
                $scope.payWindow?.close()
                $interval.cancel(getOrderInterval)
          , 1000

          $scope.$on '$destroy', ->
            $interval.cancel(getOrderInterval)

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
