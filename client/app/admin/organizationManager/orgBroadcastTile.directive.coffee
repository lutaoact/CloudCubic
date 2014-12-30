angular.module('budweiserApp')

.directive 'orgBroadcastTile', ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/admin/organizationManager/orgBroadcastTile.html'
  scope:
    organization: '='
  controller: 'OrgBroadcastTileCtrl'

.controller 'OrgBroadcastTileCtrl', (
  $scope
  $timeout
  Restangular
) ->

  angular.extend $scope,
    broadcasts: null
    newBroadcast: {}
    viewState: {}

    itemsPerPage: 5
    currentBroadcastPage: 1
    currentMessagePage: 1
    maxSize: 4

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

  # broadcast
  Restangular
  .all('broadcasts')
  .getList()
  .then (broadcasts) ->
    $scope.broadcasts = broadcasts
