'use strict'

angular.module('budweiserApp')

.directive 'courseList', ->
  restrict: 'E'
  replace: true
  controller: 'CourseListCtrl'
  templateUrl: 'app/main/course-list/course-list.html'

.controller 'CourseListCtrl', ($scope, Restangular, $q)->

  console.log 'courseList...'

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
    console.log 'allCourses', result
    $scope.allCourses = result
