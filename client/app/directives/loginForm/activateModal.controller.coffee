'use scrict'

angular.module('budweiserApp').controller 'ActivateModalCtrl', (
  $scope
  email
  Restangular
  $modalInstance
  mailAddressService
) ->
  $scope.emailHostAddress = mailAddressService.getAddress email

  angular.extend $scope,
    errors: null
    email: email

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: () ->
      Restangular.all('users').customPOST(email:$scope.email, 'sendActivationMail')
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors