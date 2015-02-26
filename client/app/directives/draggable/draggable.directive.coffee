'use strict'

angular.module('budweiserApp')

.directive 'resizable', ($document, $timeout) ->
  restrict: 'A'
  scope:
    onResize: '&'
  link: (scope, element, attrs) -> $timeout ->
    startX = 0
    startY = 0
    startWidth = 0
    startHeight = 0

    domElement = element[0].getElementsByClassName(attrs.resizable)
    toggleElement = angular.element(domElement) ? element

    console.log 'resizable', toggleElement, domElement

    toggleElement.css
      cursor: 'move'

    resetStartInfo = (event) ->
      startX = event.pageX
      startY = event.pageY
      startWidth = element[0].clientWidth
      startHeight = element[0].clientHeight

    toggleElement.on 'mousedown', (event) ->
      event.preventDefault()
      resetStartInfo(event)
      $document.on 'mousemove', mousemove
      $document.on 'mouseup', mouseup

    mousemove = (event) ->
      changeX = event.pageX - startX
      changeY = event.pageY - startY
      newWidth = Math.max(startWidth + changeX, attrs.minWidth)
      newHeight = Math.max(startHeight + changeY, attrs.minHeight)
      # 等比例缩放
      if Math.abs(changeX) > Math.abs(changeY)
        newHeight = Math.max(newWidth * startHeight / startWidth, attrs.minHeight)
      else
        newWidth = Math.max(newHeight * startWidth / startHeight, attrs.minWidth)
      newSize =
        width: newWidth
        height: newHeight
      element.css newSize
      resetStartInfo(event)
      scope?.onResize($size:newSize)

    mouseup = ->
      $document.unbind 'mousemove', mousemove
      $document.unbind 'mouseup', mouseup

.directive 'draggable', ($document, $timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) -> $timeout ->
    startX = 0
    startY = 0
    x = 0
    y = 0

    domElement = element[0].getElementsByClassName(attrs.draggable)
    toggleElement = angular.element(domElement) ? element

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
