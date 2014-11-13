'use strict'

angular.module('budweiserApp').controller 'SuperuserOrgDetailCtrl', (
  $scope
  $state
  SuperuserAPI
) ->

  angular.extend $scope,

    organization: _.find($scope.organizations, _id:$state.params.orgId)

    detail: SuperuserAPI.one("organizations", $state.params.orgId).get().$object

