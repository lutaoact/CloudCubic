'use strict'

angular.module('budweiserApp')

# 没 org 的时候会用到这个 controller
.controller 'DefaultMainCtrl', ($scope, $window, $timeout) ->

  angular.extend $scope,
    ios: '<div>ios</div>'
    distance: 800

  resize = -> $timeout ->
    $scope.distance = $window.innerHeight * 2 - 100

  resize()
  angular.element($window).bind 'resize', resize
  $scope.$on '$destroy', ->
    angular.element($window).unbind 'resize', resize
