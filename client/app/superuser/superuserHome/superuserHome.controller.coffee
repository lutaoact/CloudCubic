'use strict'

angular.module('budweiserApp')

.controller 'SuperuserHomeCtrl', (
  $scope
  $state
  Organizations
) ->

  angular.extend $scope,
    organizations: Organizations

  $scope.$on '$stateChangeSuccess', (event, toState) ->
    if toState.name == 'superuser.home'
      $state.go('superuser.home.organization', orgId:Organizations[0]?._id)
