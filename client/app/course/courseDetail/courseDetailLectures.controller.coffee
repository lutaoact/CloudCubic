'use strict'

angular.module('budweiserApp')
.controller 'CourseDetailLecturesCtrl', (
  $scope
  $state
) ->

  angular.extend $scope,
    pageConf:
      maxSize      : 20
      currentPage  : $state.params.page ? 1
      itemsPerPage : 3

  console.log $scope.pageConf.currentPage