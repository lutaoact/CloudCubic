angular.module('budweiserApp').directive 'shopcart', ->
  templateUrl: 'app/directives/shopcart/shopcart.html'
  restrict: 'EA'
  replace: true
  scope: {}
  controller: (
    $scope,
    $state,
    $rootScope,
    Restangular
  )->
    angular.extend $scope,
      removeCartItem: (classe)->
        Restangular.all('carts/remove').post classes: [classe._id]
        .then (result)->
          $scope.cartItems = result

      clearCart: ->
        classes = []
        _.map $scope.cartItems, (classe)->
          classes.push classe._id
        Restangular.all('carts/remove').post classes: classes
        .then (result)->
          $scope.cartItems = result

      makeCartOrder: ->
        classes = []
        _.map $scope.cartItems, (classe)->
          classes.push classe._id
        Restangular.all('orders').post classes: classes
        .then (order)->
          $state.go 'order', orderId: order._id

      totalPrice: ->
        if $scope.cartItems == null
          return 0
        _.reduce $scope.cartItems, (sum, classe)->
          return sum + classe['price']
        , 0


    $scope.$on 'addedToCart', (event, data)->
      console.log data
      $scope.cartItems = data

    getCartItem = ()->
      Restangular.all('carts').getList()
      .then (result)->
        $scope.cartItems = result

    $rootScope.$on 'loginSuccess', ()->
      getCartItem()

    $rootScope.$on 'logoutSuccess', ()->
      $scope.cartItems = []

    getCartItem()