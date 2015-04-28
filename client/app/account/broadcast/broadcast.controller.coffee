'use strict'

angular.module('budweiserApp').controller 'BroadcastCtrl',(
  Auth
  $scope
  notify
  Restangular
) ->

  angular.extend $scope,
    itemsPerPage: 5
    currentBroadcastPage: 1
    maxSize: 5
    broadcasts: undefined

    viewState: {}

    changeViewState: (broadcast, mousedownTimeStamp, $event)->
      if ($event.timeStamp - mousedownTimeStamp) > 100
        return
      if $scope.viewState.selectedBroadcast == broadcast
        $scope.viewState.selectedBroadcast = null
      else
        $scope.viewState.selectedBroadcast = broadcast

  Restangular.all('broadcasts').getList()
  .then (broadcasts)->
    $scope.broadcasts = broadcasts
