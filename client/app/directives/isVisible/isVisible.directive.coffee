'use strict'

# currently used in topic detail view. When I click comment button, the page
# scrolls to bottom. And it should tell the editor is visible
angular.module('budweiserApp').directive 'isVisible', ($document, $timeout, $window)->
  restrict: 'A'
  scope:
    isVisible: '='
    adjustOffsetTop:'@'
    adjustOffsetBottom:'@'
  link: (scope, $element)->
    clear = () ->
      # unbind event handle
      scrollParent.off 'scroll',scrollHandle
      scrollParent.off 'resize', scrollHandle

    topOffset = 0
    bottomOffset = 0
    lastState = undefined
    if scope.adjustOffsetTop
      topOffset = scope.adjustOffsetTop
    if scope.adjustOffsetBottom
      bottomOffset = scope.adjustOffsetBottom

    # Find element's parent, bind scroll event
    scrollParent = $element.scrollParent?() or $document

    scrollHandle = (e)->
      elemTop = $element[0].getBoundingClientRect().top
      $timeout () ->
        currentState = elemTop < $window.innerHeight + topOffset && (bottomOffset - elemTop) < 0
        if currentState isnt lastState
          lastState = currentState
          scope.isVisible = lastState

    scrollParent.on 'scroll', scrollHandle
    scrollParent.on 'resize', scrollHandle

    $element.ready scrollHandle

    scope.$on('$destroy', clear)
