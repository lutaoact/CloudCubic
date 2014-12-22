'use strict'

angular.module('budweiserApp')

.controller 'CourseListCtrl', (
  $q
  $scope
  Restangular
) ->

  angular.extend $scope,
    categories: null
    allCourses: null
    search: {}

  Restangular.all('categories').getList()
  .then (categories) ->
    $scope.categories = categories

  Restangular.all('courses/public').getList()
  .then (result)->
    classeQs = result.map (course) ->
      Restangular.all('classes').getList {courseId: course._id}
      .then (classes)->
        course.$classes = classes
        course
    $q.all(classeQs)
  .then (result)->
    console.log 'course list view', result
    $scope.allCourses = result
