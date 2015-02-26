'use strict'

angular.module('budweiserApp')

.directive 'pubLiveStream', (org, Restangular) ->
  restrict: 'EA'
  template: """<div id="live-stream-window" class="live-stream"></div>"""
  replace: true
  scope:
    onReady: '&'
    streamId: '='
  link: (scope, elem, attrs) ->
    Restangular
      .all('aodianyuns')
      .customPOST {}, 'openThenStart'
      .then (result) ->
        conf =
          container: 'live-stream-window'
          url: "rtmp://1093.lsspublish.aodianyun.com/#{org._id}/#{scope.streamId}"
          width: attrs.width
          height: attrs.height
          autoconnect: false
        pubStreamAPI = new aodianLss(conf)
        console.log 'api', pubStreamAPI, conf
        scope.onReady?($liveStreamAPI: pubStreamAPI)
      .catch (err) ->
        console.log err


.controller 'PubLiveStreamCtrl', (
  $scope
  streamId
  streamName
  Restangular
  $modalInstance
) ->

  angular.extend $scope,

    streamId: streamId
    streamName: streamName

    ready: (api) ->
      $scope.pubStreamAPI = api

    startPub: ->
      console.log 'start live stream...'
      $scope.pubStreamAPI.initConnect()
      cam = $scope.pubStreamAPI.getCam()
      mic = $scope.pubStreamAPI.getMic()

      console.log 'cam is: ', cam, 'mic is: ', mic

      publishConf =
        micID: 0
        camID: 0
        audioKBitrate: 44
        audioSamplerate: 44100
        keyFrameInterval: 30
        videoKBitrate: 256
        videoQuality: 80
        videoFPS: 10
        volume: 80
        isUseCam: true
        isUseMic: true
        isMute: false

      $scope.pubStreamAPI.startPublish(publishConf)

    stopPub: ->
      $modalInstance.close('cancel')
      $scope.pubStreamAPI.closeConnect()
