'use strict'

angular.module('budweiserApp')

.controller 'CourseListCtrl', (
  $q
  $state
  $scope
  Restangular
) ->

  angular.extend $scope,
    categories: null
    allCourses: null
    search:
      categoryId: $state.params.category
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 8

    reload: (resetPage) ->
      $scope.pageConf.currentPage = 1 if resetPage?
      $state.go('courseList', {category:$scope.search.categoryId, page:$scope.pageConf.currentPage})

  Restangular
  .all('categories')
  .getList()
  .then (categories) ->
    $scope.categories = categories

  Restangular
  .all('courses')
  .getList(
    from        : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit       : $scope.pageConf.itemsPerPage
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
