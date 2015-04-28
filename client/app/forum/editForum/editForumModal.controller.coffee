'use scrict'

angular.module('budweiserApp')

.controller 'EditForumModalCtrl', (
  $scope
  notify
  Restangular
  $modalInstance
  forum
  configs
) ->

  angular.extend $scope,
    errors: {}
    format: ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']
    forum: forum
    imageSizeLimitation: configs.imageSizeLimitation
    onLogoUpload: ($data)->
      forum.logo = $data

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      $scope.submitted = true
      if !form.$valid then return
      $scope.forum.logo or= '/assets/images/discussion-boards.jpg'
      (
        if $scope.forum._id?
          Restangular.one('forums', $scope.forum._id).patch($scope.forum)
        else
          Restangular.all('forums').post($scope.forum)
      )
      .then $modalInstance.close
      .catch (error) ->
        angular.forEach error?.data?.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message
