'use strict'

angular.module('budweiserApp').controller 'TeacherTeachingCtrl', (
  $sce
  $scope
  $state
  $modal
  $timeout
  Restangular
) ->

  # TODO: remove this line. Fix in videogular
  $scope.$on '$destroy', ()->
    # clear video
    angular.element('video').attr 'src', ''

  angular.extend $scope,
    isFullScreen: false
    $state: $state
    currentPage: 0
    currentNum: 1
    showAllSlide: false
    showVideo: false
    showLive : false
    lecture: null
    selectedFile: null
    lss : null

    changeCurrentIndex: (index) ->
      $scope.currentIndex = index

    switchFile: (file) ->
      $scope.selectedFile = file

    toggleFullScreen: ->
      $scope.isFullScreen = !$scope.isFullScreen

    toggleSlides: ->
      $scope.showVideo = false
      $scope.showAllSlide = !$scope.showAllSlide

    toggleVideo: ->
      $scope.showAllSlide = false
      $scope.showVideo = !$scope.showVideo

    toggleLive: ->
      console.log 'toggleLive...'
      $scope.showLive = !$scope.showLive
      
    pushQuestion: (quizze) ->
      $modal.open
        templateUrl: 'app/teacher/teacherTeaching/pubQuestion.html'
        controller: 'PubQuestionCtrl'
        backdrop: 'static'
        windowClass: 'pub-question-modal'
        resolve:
          classe: -> $scope.classe
          lecture: -> $scope.lecture
          question: -> quizze
      .result.then ->

    genTooltip: (showMenu) ->
      if !showMenu then '推送随堂练习'

    moving: false
    onMouseMove: ()->
      if not @moving
        $scope.moving = true
        $timeout ->
          angular.element('#controls-container').mousemove()
        $timeout ->
          $scope.moving = false
        , 500

    startLiveStream : () ->
      console.log 'start live stream...'
      
      $scope.lss.initConnect()

      cam = $scope.lss.getCam()
      console.log 'cam is: ', cam
      
      mic = $scope.lss.getMic()
      console.log 'mic is: ', mic
      
      publishConf =
        micID:0
        camID:0
        audioKBitrate:44
        audioSamplerate:44100
        videoFPS:10
        keyFrameInterval:30
        videoKBitrate:256
        videoQuality:80
        volume:80
        isUseCam:true
        isUseMic:true
        isMute:false
      
      $scope.lss.startPublish(publishConf);
    
    stopLiveStream : () ->
      console.log 'close live stream...'
      $scope.lss.closeConnect()
      
  $scope.$watch 'currentIndex', ->
    $scope.currentNum = $scope.currentIndex + 1

  Restangular.all('activities').post
    eventType: Const.Teacher.ViewLecture
    data:
      lectureId: $state.params.lectureId
      courseId: $state.params.courseId
      classeId: $state.params.classeId

  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    $scope.course = course
  Restangular.one('classes', $state.params.classeId).get()
  .then (classe) ->
    $scope.classe = classe
  Restangular.one('lectures', $state.params.lectureId).get()
  .then (lecture) ->
    $scope.lecture = lecture
    $scope.switchFile(lecture.files[0])
    $scope.lecture.$mediaSource = [
      src: $sce.trustAsResourceUrl(lecture.media)
      type: 'video/mp4'
    ]

    ###
  $scope.lss = new aodianLss(
    container: 'live-stream-window'
    #url : "rtmp://1093.lsspublish.aodianyun.com/#{$scope.classe._id}/stream"
    url : "rtmp://1093.lsspublish.aodianyun.com/cloud3edu/stream"
    width: '320'
    height: '240'
    #autoconnect: true
  )

  
###
  

  Restangular.all('aodianyuns').customPOST {}, 'openThenStart'
  .then (result) ->
    url = "rtmp://1093.lsspublish.aodianyun.com/#{result.appid}/#{$state.params.classeId}"
    console.log url
    $scope.lss = new aodianLss(
      container: 'live-stream-window'
      url : url
      width: '320'
      height: '240'
      #autoconnect: true
    )
  .catch (err) ->
    console.log err
