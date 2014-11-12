'use strict'

angular.module('budweiserApp').controller 'NoticeCtrl',(
  Auth
  $scope
  notify
  Restangular
) ->

  angular.extend $scope,

    broadcasts: undefined

    messages: undefined

    viewState: {}

  Restangular.all('notices').getList()
  .then (notices)->
    $scope.messages = notices

  Restangular.all('broadcasts').getList()
  .then (broadcasts)->
    console.log 1
    $scope.broadcasts = broadcasts
