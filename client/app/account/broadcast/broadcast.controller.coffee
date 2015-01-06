'use strict'

angular.module('budweiserApp').controller 'BroadcastCtrl',(
  Auth
  $scope
  notify
  Restangular
  $rootScope
  Msg
) ->

  angular.extend $scope,
    itemsPerPage: 5
    currentBroadcastPage: 1
    maxSize: 4
    broadcasts: undefined

  Restangular.all('broadcasts').getList()
  .then (broadcasts)->
    $scope.broadcasts = broadcasts
