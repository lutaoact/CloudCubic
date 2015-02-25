'use strict'

angular.module('budweiserApp')

.directive 'subLiveStream', (org, $interval) ->
  restrict: 'EA'
  template: """<div id="live-stream-window" class="live-stream"></div>"""
  replace: true
  scope:
    onReady: '&'
    streamId: '='
  link: (scope, elem, attrs) ->
    aodianPlayer(
      container: 'live-stream-window'
      rtmpUrl:"rtmp://1093.lssplay.aodianyun.com/#{org._id}/#{scope.streamId}"
      player:
        name:'lssplayer'
        width: '360'
        height: '240'
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

    startPlay: ->
      $scope.subStreamAPI.pause()
      $scope.subStreamAPI.startPlay()

    stopPlay: ->
      $scope.subStreamAPI.stopPlayer()
      $scope.subStreamAPI.closeConnect()
      $modalInstance.close('cancel')

