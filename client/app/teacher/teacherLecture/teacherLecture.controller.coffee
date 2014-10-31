'use strict'

angular.module('budweiserApp').controller 'TeacherLectureCtrl', (
  Auth
  $http
  $scope
  $state
  $modal
  notify
  Navbar
  $filter
  Courses
  KeyPoints
  Restangular
  $sce
) ->

  course = _.find Courses, _id :$state.params.courseId

  Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  # TODO: remove this line. Fix in videogular
  $scope.$on '$destroy', ()->
    # clear video
    angular.element('video').attr 'src', ''

  angular.extend $scope,

    course: course
    keyPoints: KeyPoints
    mediaApi: null
    saving: false
    deleting: false
    videoActive: true
    lecture: null
    editingInfo: null
    editingProgress: # 0=new, 1/2=half, 1=done
      info: 1
      media: 1
      question: 1
      done: 3 # 多少个已经完成的
    viewState:
      questionType: 'quizzes' # quizzes / homeworks / offlineWorks

    switchEdit: ->
      $scope.editingInfo =
        if !$scope.editingInfo?
          _.pick $scope.lecture, [
            'name'
            'info'
            'thumbnail'
          ]
        else
          null

    deleteLecture: ->
      lecture = $scope.lecture
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时'
          message: -> """确认要删除《#{$scope.course.name}》中的"#{lecture.name}"？"""
      .result.then ->
        $scope.deleting = true
        $scope.lecture.remove(courseId:$scope.course._id)
        .then ->
          $scope.deleting = false
          $scope.editingInfo = null
          $scope.lecture = null
          $state.go('teacher.course', courseId:$scope.course._id)

    saveLecture: (form) ->
      unless form?.$valid then return
      $scope.saving = true
      lecture = $scope.lecture
      editingInfo = $scope.editingInfo
      lecture.patch(editingInfo)
      .then (newLecture) ->
        angular.extend lecture, editingInfo
        $scope.saving = false
        $scope.editingInfo = null
        $scope.updateEditingProgress(newLecture)
        notify
          message:'课时信息已保存'
          classes:'alert-success'

    saveLectureDesc: () ->
      $scope.saving = true
      $scope.lecture.patch desc: $scope.lecture.desc
      .then (newLecture)->
        $scope.saving = false
        $scope.updateEditingProgress(newLecture)
        notify
          message:'课时详细内容已保存'
          classes:'alert-success'

    removeMedia: ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课时视频'
          message: -> """确认要删除"#{$scope.lecture.name}"的视频？"""
      .result.then ->
        $scope.lecture.media = null
        $scope.lecture.$mediaSource = [
        ]
        $scope.lecture.patch?(media: $scope.lecture.media)
        .then $scope.updateEditingProgress

    onError: (error) ->
      notify
        message: '上传失败：' + error
        classes: 'alert-danger'
    onMediaUploadStart: ->
      console.debug 'media upload start'
    onMediaUploading: (speed, progress, event) ->
      console.debug 'media uploading', speed, progress
    onMediaConverting: ->
      console.debug 'media converting'
    onMediaUploaded: (data) ->
      $scope.lecture.patch?(media: data)
      .then (newLecture)->
        # the backend
        $scope.lecture.media = data
        $scope.lecture.$mediaSource = [
          {
            src: $sce.trustAsResourceUrl($scope.lecture.media)
            type: 'video/mp4'
          }
          {
            src : 'http://trymedia.origin.mediaservices.chinacloudapi.cn/c8e1a25b-f379-4a79-8f3f-4c92d3b3de37/shit.ism/Manifest'
            type: 'manifest'
          }
        ]
        $scope.updateEditingProgress(newLecture)

    onPlayerReady: (api) ->
      $scope.mediaApi = api

    updateEditingProgress: (newLecture = null) ->
      lecture = $scope.lecture
      lecture.__v = newLecture.__v if newLecture?
      progress = $scope.editingProgress
      progress.info = 0
      progress.media = 0
      progress.question = 0
      progress.info += 1/2 if lecture.name?.length > 0
      progress.info += 1/2 if lecture.info?.length > 0
      progress.media += 1/2 if lecture.media?.length > 0
      progress.media += 1/2 if lecture.files?.length > 0
      progress.question += 1/2 if lecture.quizzes?.length > 0
      progress.question += 1/2 if lecture.homeworks?.length > 0
      progress.done = progress.info + progress.media + progress.question

    genTooltip: (progress, label) ->
      label +
        if progress == 0 then '未添加'
        else if progress == 1/2 then '不完整'
        else '已添加'

    # todo: use http://modernizr.com/docs/
    supportHLS: true

  Restangular.one('lectures', $state.params.lectureId).get()
  .then (lecture) ->
    lecture.$mediaSource = [
      src: $sce.trustAsResourceUrl(lecture.media)
      type: 'video/mp4'
    ]
    $scope.lecture = lecture
    $scope.videoActive = lecture.media? || lecture.files.length == 0
    $scope.switchEdit() if lecture.__v == 0
    $scope.updateEditingProgress()

  # 删除未保存过的课时
  $scope.$on '$destroy', ->
    $scope.lecture.remove(courseId:$scope.course._id) if $scope.lecture?.__v == 0
