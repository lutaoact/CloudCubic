'use strict'

angular.module('budweiserApp')

.controller 'OrganizationManagerCtrl', (
  org
  notify
  $scope
  configs
  Restangular
  orgTypeService
) ->

  editableFields = [
    'name'
    'type'
    'uniqueName'
    'customDomain'
    'description'
    'telephone'
    ]

  angular.extend $scope,
    imageSizeLimitation: configs.imageSizeLimitation
    organization: null
    editingInfo: null
    errors: null
    saving: false
    saved: true
    alipaySaving: false
    alipaySaved: true
    orgAlipay: null
    orignOrgAlipay: {}

    orgTypes: orgTypeService.getList()

    onLogoUpload: (key) ->
      $scope.organization.logo = key
      Restangular
      .one('organizations', $scope.organization._id)
      .patch logo: key
      .then ->
        notify
          message: 'Logo 修改成功'
          classes: 'alert-success'

    saveOrg: (form)->
      if !form.$valid then return
      $scope.saving = true
      $scope.errors = null
      Restangular
      .one('organizations', $scope.organization._id)
      .patch($scope.editingInfo)
      .then ->
        angular.extend $scope.organization, $scope.editingInfo
        $scope.saving = false
      .catch (error) ->
        $scope.errors = error?.data?.errors
        $scope.saving = false

    saveOrgAlipay: ->
      $scope.alipaySaving = true
      Restangular
      .one('org_alipays','me')
      .patch $scope.orgAlipay
      .then ->
        angular.extend $scope.orignOrgAlipay, $scope.orgAlipay
      .finally ->
        $scope.alipaySaving = false


  Restangular
  .one('org_alipays','me').get()
  .then (data) ->
    $scope.orgAlipay = data ? {}
    angular.extend $scope.orignOrgAlipay, $scope.orgAlipay

  Restangular
  .one('organizations', org._id)
  .get()
  .then (dbOrg) ->
    $scope.organization = dbOrg
    $scope.editingInfo = _.pick $scope.organization, editableFields

  $scope.$watch ->
    _.isEqual($scope.editingInfo, _.pick $scope.organization, editableFields)
  , (isEqual) ->
    $scope.saved = isEqual

  $scope.$watch ->
    _.isEqual($scope.orgAlipay, $scope.orignOrgAlipay)
  , (isEqual) ->
    $scope.alipaySaved = isEqual