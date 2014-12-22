'use strict'

angular.module('budweiserApp').directive 'courseTile', (Restangular)->
  templateUrl: 'app/directives/courseTile/courseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->
    scope.$watch 'course', (value)->
      if value
        Restangular.all('progresses').getList({courseId: value._id})
        .then (progress)->
          scope.percentageCalculated = true
          scope.percentage = ~~(100.0 * progress?.length / value.lectureAssembly.length)

.directive 'publicCourseTile', ->
  templateUrl: 'app/directives/courseTile/publicCourseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->
