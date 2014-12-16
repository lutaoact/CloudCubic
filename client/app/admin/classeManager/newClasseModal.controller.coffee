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
      enrollment: {}
      duration: {}
    courses: Courses
    format: ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      $scope.errors = null
      Restangular.all('classes').post($scope.classe)
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors
