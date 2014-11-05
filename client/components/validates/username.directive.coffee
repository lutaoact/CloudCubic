'use strict'

angular.module('budweiserApp').directive 'username',($q, Restangular) ->
  require: 'ngModel',
  link: (scope, elm, attrs, ctrl) ->
    console.log ctrl, scope
    # 1.3
    # ctrl.$asyncValidators.username = (modelValue, viewValue) ->
    #   if ctrl.$isEmpty(modelValue)
    #     # consider empty model valid
    #     return $q.when()
    #   def = $q.defer()
    #   Restangular.one('users', 'check').get(username: modelValue)
    #   .then ()->
    #     def.resolve()
    #   , ()->
    #     def.reject()
