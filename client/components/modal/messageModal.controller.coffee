'use strict'

angular.module('budweiserApp').controller 'MessageModalCtrl', (
  title
  $scope
  message
  $modalInstance
) ->
  angular.extend $scope,
    title: title
    buttons: ['确认']
    message: message
    confirmButtonFocus: []
    cancel: ->
      $modalInstance.dismiss()
    confirm: (confirmIndex) ->
      $modalInstance.close(confirmIndex)

angular.module('budweiserApp').controller 'AdvanceMessageModalCtrl', (
  title
  $scope
  message
  buttons
  $controller
  $modalInstance
) ->

  # extend controller MessageModalCtrl
  angular.extend @, $controller('MessageModalCtrl',
    $scope: $scope
    title: title
    message: message
    $modalInstance: $modalInstance
  )

  # override the buttons property
  angular.extend $scope,
    buttons: buttons

