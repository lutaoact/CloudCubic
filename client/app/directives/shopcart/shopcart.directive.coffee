angular.module('budweiserApp').directive 'shopcart', ->
  templateUrl: 'app/directives/shopcart/shopcart.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->