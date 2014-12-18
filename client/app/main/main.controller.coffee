'use strict'

angular.module('budweiserApp')

.controller 'MainCtrl', (org, Page, $scope) ->
  Page.setTitle '云立方学院 cloud3edu 提供教育云服务，教育的云计算时代，从云立方学院开始'

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

# 有 org 的时候会用到这个 controller
.controller 'OrgMainCtrl', ($scope) ->

  console.log 'OrgMainCtrl', $scope.org
