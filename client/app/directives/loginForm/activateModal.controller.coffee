'use scrict'

angular.module('budweiserApp').controller 'ActivateModalCtrl', (
  $scope
  email
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    errors: null
    email: email

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      Restangular.all('users').customPOST(email:$scope.email, 'sendActivationMail')
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors