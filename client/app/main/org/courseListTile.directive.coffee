'use strict'

angular.module('budweiserApp')

.directive 'courseListTile', ->
  restrict: 'E'
  replace: true
  scope:
    limit: '@'
  controller: 'CourseListTileCtrl'
  templateUrl: 'app/main/org/courseListTile.html'

.controller 'CourseListTileCtrl', ($scope, Restangular, $q)->

  angular.extend $scope,
    categories: null
    allClasses: null
    search: {}

  Restangular
  .all('categories')
  .getList()
  .then (categories) ->
    $scope.categories = categories

  $scope.$watch 'search.categoryId', (categoryId) ->
    Restangular
    .all('classes')
    .getList(limit:$scope.limit ? 8, categoryId:categoryId)
    .then (classes) ->
      $scope.allClasses = classes
