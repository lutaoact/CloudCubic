'use strict'

angular.module('budweiserApp').controller 'ForumListCtrl', (
  $q
  $scope
  $state
  Navbar
  Auth
  Restangular
) ->

  Restangular.all('forums').getList()
  .then (forums)->
    $scope.forums = forums

  angular.extend $scope,
    itemsPerPage: 12
    currentPage: 1
    maxSize: 5

