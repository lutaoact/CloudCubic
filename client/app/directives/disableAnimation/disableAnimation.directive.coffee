'use strict'

angular.module('budweiserApp').directive 'disableAnimation', ($animate)->
  restrict: 'A'
  link: (scope, element) ->
    $animate.enabled false, element
