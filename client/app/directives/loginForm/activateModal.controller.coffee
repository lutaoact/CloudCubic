'use scrict'

angular.module('budweiserApp').controller 'ActivateModalCtrl', (
  email
  $scope
  Restangular
  $modalInstance
  mailAddressService
) ->

  angular.extend $scope,
    email: email
    emailHostAddress: mailAddressService.getAddress email
    viewState:
      sending: false

    cancel: ->
      $modalInstance.dismiss('cancel')

    resendEmail: () ->
      $scope.viewState.sending = true
      $scope.errors = null
      Restangular.all('users').customPOST(email:$scope.email, 'sendActivationMail')
      .then $modalInstance.close
      .finally ->
        $scope.viewState.sending = false