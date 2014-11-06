'use strict'

angular.module('budweiserApp').controller 'OrganizationManagerCtrl', (
  Auth
  $http
  $modal
  notify
  $scope
  $upload
  Restangular
  configs
) ->

  editableFields = [
    'name'
    'type'
    'description'
    ]

  angular.extend $scope,
    imageSizeLimitation: configs.imageSizeLimitation
    organization: null
    editingInfo: null
    saving: false
    saved: true

    orgTypes: [
      "小学"
      "初中"
      "高中"
      "大学"
      "职业学校"
      "培训机构"
    ]

    onLogoUpload: (key) ->
      $scope.organization.logo = key
      Restangular.one('organizations', $scope.organization._id).patch logo: key
      .then ->
        notify
          message: 'Logo 修改成功'
          classes: 'alert-success'

    saveOrg: (form)->
      if !form.$valid then return
      $scope.saving = true
      angular.extend $scope.organization, $scope.editingInfo
      $scope.organization.put().then ->
        $scope.saving = false

  Auth.getCurrentUser().$promise.then (me) ->
    Restangular.one('organizations', me.orgId._id).get()
    .then (org) ->
      $scope.organization = org
      $scope.editingInfo = _.pick $scope.organization, editableFields

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.organization, editableFields)
  , (isEqual) ->
    $scope.saved = isEqual

