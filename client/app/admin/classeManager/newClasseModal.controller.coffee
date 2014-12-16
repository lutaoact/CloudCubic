'use scrict'

angular.module('budweiserApp').controller 'NewClasseModalCtrl', (
  $scope
  Courses
  Restangular
  $modalInstance
) ->

  angular.extend $scope,
    errors: null
    classe:
      name: ''
      price: 0
    courses: Courses

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      console.log $scope.classe
      return
      if !form.$valid then return
      $scope.errors = null
      Restangular.all('classes').post($scope.classe)
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors
