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
    maxSize      : 5
    currentPage  : 1
    itemsPerPage : 8

  Restangular
  .all('categories')
  .getList()
  .then (categories) ->
    $scope.categories = categories

  $scope.$watchCollection '[search.categoryId, currentPage]', ->
    Restangular
    .all('courses')
    .getList(
      from        : ($scope.currentPage - 1) * $scope.itemsPerPage
      limit       : $scope.itemsPerPage
      categoryIds : $scope.search.categoryId
    )
    .then (courses) ->
      $scope.allCourses = courses
      angular.forEach courses, (course) ->
        Restangular
        .all('classes')
        .getList courseId: course._id
        .then (classes)->
          course.$classes = classes
