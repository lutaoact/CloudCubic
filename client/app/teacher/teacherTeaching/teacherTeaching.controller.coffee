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
    lecture: null
    selectedFile: null

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

