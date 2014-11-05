'use strict'

angular.module('budweiserApp').directive 'sameWith', () ->
  require: 'ngModel',
  scope:
    sameWith: "="
  link: (scope, element, attributes, ngModel) ->
    # 1.30
    # ngModel.$validators?.sameWith = (modelValue) ->
    #   modelValue is scope.sameWith
    # scope.$watch "sameWith", () ->
    #   ngModel.$validate?()
