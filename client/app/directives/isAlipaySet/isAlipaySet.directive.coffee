'use strict'

angular.module('budweiserApp').directive 'isAlipaySet', (Restangular, $timeout)->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, ele, attrs, c)->
    ele.on 'blur', ->
      $timeout ->
        console.log c.$modelValue
        if (c.$modelValue == 0) || (c.$modelValue == undefined)
          c.$setValidity('aplipaySet', true);
        else
          Restangular.one('org_alipays','isSet').get()
          .then (data)->
            c.$setValidity('aplipaySet', data['isSet']);

