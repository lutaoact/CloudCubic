'use strict'

angular.module('budweiserApp')

.directive 'subLiveStream', (org, $interval) ->
  restrict: 'EA'
  template: """<div id="live-stream-window" class="live-stream"></div>"""
  replace: true
  scope:
    onReady: '&'
    streamId: '='
    width: '@'
    height: '@'
  link: (scope, elem, attrs) ->
    aodianPlayer(
      container: 'live-stream-window'
      rtmpUrl:"rtmp://1093.lssplay.aodianyun.com/orgId_#{org._id}/classeId_#{scope.streamId}"
      player:
        name:'lssplayer'
        width: scope.width
        height: scope.height
        autostart: true
        bufferlength: '3'
        stretching: '1'
        controlbardisplay: 'enable'
    )
    checkAPI = $interval ->
      if lssHandle
        $interval.cancel(checkAPI)
        scope.onReady($liveStreamAPI: lssHandle)
    , 500

.controller 'PlayLiveStreamCtrl', (
  $scope
  streamId
  streamName
  Restangular
  $modalInstance
) ->

  angular.extend $scope,

    streamId: streamId
    streamName: streamName

    subStreamAPI: null

    ready: (subStreamAPI) ->
      $scope.subStreamAPI = subStreamAPI

    resize: (size) ->
      #$scope.size = size

    startPlay: ->
      $scope.subStreamAPI.pause()
      $scope.subStreamAPI.startPlay()

    stopPlay: ->
      $scope.subStreamAPI.stopPlayer()
      $scope.subStreamAPI.closeConnect()
      $modalInstance.close('cancel')

