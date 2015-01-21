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
      category: $state.params.category
      keyword: $state.params.keyword
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 2

    reload: (resetPage) ->
      $scope.pageConf.currentPage = 1 if resetPage?
      $state.go 'courseList',
        category:$scope.search.category
        keyword:$scope.search.keyword
        page:$scope.pageConf.currentPage

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
    categoryId : $scope.search.category
    keyword    : $scope.search.keyword
    sort       : JSON.stringify {setTop:-1, created:-1}
  )
  .then (classes) ->
    $scope.allClasses = classes
