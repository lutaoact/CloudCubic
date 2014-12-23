'use strict'

angular.module('budweiserApp')

.directive 'courseListTile', ->
  restrict: 'E'
  replace: true
  controller: 'CourseListTileCtrl'
  templateUrl: 'app/main/org/courseListTile.html'

.controller 'CourseListTileCtrl', ($scope, Restangular, $q)->

  angular.extend $scope,
    categories: null
    allCourses: null
    search: {}

  Restangular
  .all('categories')
  .getList()
  .then (categories) ->
    $scope.categories = categories

  $scope.$watch 'search.categoryId', (categoryId) ->
    Restangular
    .all('courses')
    .getList(limit:4, categoryIds:categoryId)
    .then (result) ->
      classeQs = result.map (course) ->
        Restangular
        .all('classes')
        .getList courseId: course._id
        .then (classes)->
          course.$classes = classes
          course
      $q.all(classeQs)
    .then (result)->
      $scope.allCourses = result
