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
    allClasses: null
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
  .all('classes')
  .getList(
    from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit      : $scope.pageConf.itemsPerPage
    categoryId : $scope.search.categoryId
  )
  .then (classes) ->
    console.log 'all classes', classes
    $scope.allClasses = classes
