'use strict'

angular.module('budweiserApp').directive 'courseTile', ->
  templateUrl: 'app/directives/courseTile/courseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->

.directive 'publicCourseTile', ->
  templateUrl: 'app/directives/courseTile/publicCourseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->
