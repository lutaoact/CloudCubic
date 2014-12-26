'use scrict'

angular.module('budweiserApp')

.controller 'EditForumModalCtrl', (
  $scope
  Category
  notify
  Restangular
  $modalInstance
  forum
  configs
) ->
  Category.find()
  .then (categories)->
    $scope.categories = categories
    other = {name:'其他'}
    $scope.categories.push other
    if forum.categoryId
      forum.categoryId = _.find $scope.categories, (category)->
        category._id is forum.categoryId._id
    else
      forum.categoryId = other

  angular.extend $scope,
    errors: null
    format: ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']
    forum: forum
    imageSizeLimitation: configs.imageSizeLimitation
    onLogoUpload: ($data)->
      forum.logo = $data

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      $scope.errors = null
      (
        if $scope.forum._id?
          Restangular.one('forums', $scope.forum._id).patch($scope.forum)
        else
          Restangular.all('forums').post($scope.forum)
      )
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors
        notify
          message: '编辑讨论组失败'
          forums: 'alert-danger'

  if $scope.forum.$category
    $scope.forum.categoryId = $scope.forum.$category
