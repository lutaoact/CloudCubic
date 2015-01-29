'use strict'

angular.module('budweiserApp').directive 'isAlipaySet', (Restangular, $timeout)->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, ele, attrs, c)->
    ele.on 'blur', ->
      $timeout ->
        if (c.$modelValue == 0) || (c.$modelValue == undefined)
          c.$setValidity('aplipaySet', true)
        else
          Restangular.one('org_alipays','isSet').get()
          .then (data) ->
            isSet = eval(data)
            c.$setValidity('aplipaySet', isSet)

