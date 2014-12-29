'use strict'

angular.module('budweiserApp').controller 'CommentsSiderCtrl',
(
  $scope
  Restangular
  $state
  $q
  $rootScope
  $window
  $timeout
  $modal
  Auth
  $filter
) ->

  if not $state.params.courseId
    return
  angular.extend $scope,


