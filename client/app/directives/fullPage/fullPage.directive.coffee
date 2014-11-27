'use strict'

angular.module('budweiserApp').directive 'fullPage', ($window) ->
  restrict: 'A'
  link:($scope,$element) ->
    initializeWindowSize = ->
      $element.css('width', $window.innerWidth)
      $element.css('height', $window.innerHeight)

    initializeWindowSize()

    angular.element($window).bind 'resize', ->
      initializeWindowSize()
