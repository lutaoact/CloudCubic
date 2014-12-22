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

  Restangular.all('categories').getList()
  .then (categories) ->
    $scope.categories = categories

  Restangular.all('courses/public').getList()
  .then (result) ->
    classeQs = result.map (course) ->
      Restangular.all('classes').getList {courseId: course._id}
      .then (classes)->
        course.$classes = classes
        course
    $q.all(classeQs)
  .then (result)->
    console.log 'course list tile', result
    $scope.allCourses = result
