'use strict'

angular.module('budweiserApp')

.directive 'draggable', ($document) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    startX = 0
    startY = 0
    x = 0
    y = 0

    toggleClasseName = document.getElementsByClassName(attrs.draggable)
    toggleElement = angular.element(toggleClasseName) ? element

    element.css
      position: 'fixed'
    toggleElement.css
      cursor: 'move'

    toggleElement.on 'mousedown', (event) ->
      # Prevent default dragging of selected content
      event.preventDefault()
      startX = event.screenX - x
      startY = event.screenY - y
      $document.on 'mousemove', mousemove
      $document.on 'mouseup', mouseup

    mousemove = (event) ->
      y = event.screenY - startY
      x = event.screenX - startX
      element.css
        top: y + 'px'
        left: x + 'px'

    mouseup = ->
      $document.unbind 'mousemove', mousemove
      $document.unbind 'mouseup', mouseup
