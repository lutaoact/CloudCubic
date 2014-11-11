'use strict'

angular.module('budweiserApp').controller 'SuperuserCtrl', (
  $scope
) ->

  angular.extend $scope,
    menus: [
      stateName:'superuser.home'
      className: 'budon budon-organization'
      label: '所有机构'
    ]
