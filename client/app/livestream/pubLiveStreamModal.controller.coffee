'use strict'

angular.module('budweiserApp')

.directive 'pubLiveStream', (org, Restangular) ->
  restrict: 'EA'
  template: """<div id="live-stream-window" class="live-stream"></div>"""
  replace: true
  scope:
    onReady: '&'
    streamId: '='
    width: '@'
    height: '@'
  link: (scope, elem, attrs) ->
    Restangular
      .all('aodianyuns')
      .customPOST {}, 'openThenStart'
      .then (result) ->
        conf =
          container: 'live-stream-window'
          url: "rtmp://1093.lsspublish.aodianyun.com/#{org._id}/#{scope.streamId}"
          width: scope.width
          height: scope.height
          autoconnect: true
        pubStreamAPI = new aodianLss(conf)
        scope.onReady?($liveStreamAPI: pubStreamAPI)
      .catch (err) ->
        console.log err


.controller 'PubLiveStreamCtrl', (
  $scope
  $timeout
  streamId
  streamName
  Restangular
  $modalInstance
) ->

  angular.extend $scope,

    streamId: streamId
    streamName: streamName
    pubStreamAPI: null

    # RtmpMedia.Initialize.Success
    # NetStream.Publish.Start
    # Call : CloseStream
    stateInfo: 'none'

    ready: (api) ->
      $scope.pubStreamAPI = api
      $scope.pubStreamAPI.setStateWatch (state) -> $timeout ->
        console.log state
        $scope.stateInfo =
          switch state
            when 'RtmpMedia.Initialize.Success'
              'init'
            when 'NetStream.Publish.Start'
              'start'
            when 'Call : CloseStream'
              'pause'
            else
              'none'

    resize: (size) ->
      #$scope.size = size

    startPub: ->
      if $scope.stateInfo is 'start'
        $scope.pubStreamAPI.pause()
      else
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

