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
      currentPage  : $state.params.page
      itemsPerPage : 2

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

  $scope.$watchCollection '[search.categoryId, pageConf.currentPage]', (newVal)->
    $state.go('courseList', {category:newVal[0], page:newVal[1]})
