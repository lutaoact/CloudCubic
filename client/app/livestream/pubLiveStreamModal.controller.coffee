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
  notify
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
    selectedMic: null
    selectedCam: null
    micArray: []
    camArray: []

    ready: (api) ->
      $scope.pubStreamAPI = api
      $scope.pubStreamAPI.setStateWatch (state) -> $timeout ->
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
        if $scope.stateInfo is 'init'
          transform = (array) ->
            _.transform array, (result, name, id) ->
              result.push
                id: id
                name: name
            , []
          $scope.micArray = transform api.getMic()
          $scope.camArray = transform api.getCam()
          $scope.selectedMic = $scope.micArray[0]
          $scope.selectedCam = $scope.camArray[0]
          console.log $scope.micArray, $scope.camArray

    resize: (size) ->
      #$scope.size = size

    startPub: ->
      if $scope.stateInfo is 'start'
        $scope.pubStreamAPI.pause()
      else
        if !$scope.micArray?.length
          notify
            message: "直播未能开始：未检查到设备上的麦克风"
            classes: 'alert-warning'
          return
        if !$scope.camArray?.length
          notify
            message: "直播未能开始：未检查到设备上的摄像头"
            classes: 'alert-warning'
          return
        if !$scope.selectedMic or !$scope.selectedCam
          notify
            message: "直播未能开始：请先选择直播的麦克风和摄像头"
            classes: 'alert-warning'
          return
        publishConf =
          micID: $scope.selectedMic.id
          camID: $scope.selectedCam.id
        $scope.pubStreamAPI.startPublish(publishConf)

    stopPub: ->
      $modalInstance.close('cancel')
      $scope.pubStreamAPI.closeConnect()

