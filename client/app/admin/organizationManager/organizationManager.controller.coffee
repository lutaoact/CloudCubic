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
  $timeout
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

  # broadcast
  Restangular.all('broadcasts').getList()
  .then (broadcasts)->
    $scope.broadcasts = broadcasts

  angular.extend $scope,
    broadcasts: undefined

    newBroadcast: {}

    postBroadcast: (form)->

      if form.$valid
        # Account created, redirect to home
        Restangular.all('broadcasts').post $scope.newBroadcast
        .then (newBroadcast)->
          $scope.newBroadcast = {}
          $scope.broadcasts.splice 0, 0, newBroadcast

    removeBroadcast: (broadcast)->
      $scope.broadcasts.splice $scope.broadcasts.indexOf(broadcast), 1
      broadcast.remove()
      .then ->
        notify
          message: '删除成功'
          classes: 'alert-success'

    viewState: {}

    resend: (broadcast)->
      broadcastForm = angular.element '.broadcast-form'
      broadcastForm.addClass 'blink'
      $timeout ->
        broadcastForm.removeClass 'blink'
      , 800
      broadcastEle = undefined
      $timeout ->
        broadcastEle = angular.element('#'+broadcast._id).append('<div class="outer"></div>')

      outer = undefined
      $timeout ->
        outer = broadcastEle.find('.outer')
        width = (outer.outerWidth() - outer.innerWidth()) / 2
        broadcastForm = angular.element('.broadcast-form')
        outer.offset
          top: broadcastForm.offset().top-width
          left: broadcastForm.offset().left-width
        outer.height broadcastForm.height()
        outer.width broadcastForm.width()
      , 100

      $timeout ->
        $scope.newBroadcast ?= {}
        $scope.newBroadcast.title = broadcast.title
        $scope.newBroadcast.content = broadcast.content
      , 800

      $timeout ->
        outer.remove()
      , 800
