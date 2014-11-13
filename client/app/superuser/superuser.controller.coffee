'use strict'

angular.module('budweiserApp')

.factory 'SuperuserAPI', (Restangular) ->
  Restangular.withConfig (RestangularConfigurer) ->
    RestangularConfigurer.setBaseUrl('api/superuser')

.controller 'SuperuserCtrl', (
  $scope
) ->
