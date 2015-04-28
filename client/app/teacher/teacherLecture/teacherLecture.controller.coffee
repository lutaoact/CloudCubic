'use strict'

angular.module('budweiserApp')

.controller 'TeacherLectureCtrl', (
  $sce
  $http
  $scope
  $state
  notify
  $filter
  configs
  KeyPoints
  $rootScope
  Restangular
  messageModal
) ->

  Restangular
  .one('courses', $state.params.courseId)
  .get()
  .then (course) ->
    $scope.course = course

  Restangular
  .all('classes')
  .getList courseId: $state.params.courseId
  .then (classes) ->
    $scope.classes = classes

  # TODO: remove this line. Fix in videogular
  $scope.$on '$destroy', ()->
    # clear video
    angular.element('video').attr 'src', ''
  angular.extend $scope,
    videoLimitation: if $rootScope.org.paid then configs.proVideoSizeLimitation else configs.videoSizeLimitation
    keyPoints: KeyPoints
    mediaApi: null
    saving: false
    deleting: false
    lecture: null
    editingInfo: null
    editingProgress: # 0=new, 1/2=half, 1=done
      info: 1
      media: 1
      question: 1
      done: 3 # 多少个已经完成的
    viewState:
      videoActive: true
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

    switchFreeTry: ->
      lecture = $scope.lecture
      lecture.patch(isFreeTry: !lecture.isFreeTry)
      .then (newLecture) ->
        lecture.isFreeTry = newLecture.isFreeTry
        notify
          message: if lecture.isFreeTry then '已设置免费试用' else '已取消免费试用'
          classes:'alert-success'

    deleteLecture: ->
      lecture = $scope.lecture
      messageModal.open
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
      messageModal.open
        title: -> '删除课时视频'
        message: -> """确认要删除"#{$scope.lecture.name}"的视频？"""
      .result.then ->
        $scope.lecture.media = null
        $scope.lecture.externalMedia = null
        $scope.lecture.$externalMedia = null
        $scope.lecture.$mediaSource = [
        ]
        $scope.lecture.patch?(media: $scope.lecture.media, externalMedia: null)
        .then $scope.updateEditingProgress

    onError: (error) ->
      notify
        message: '上传失败：' + error
        classes: 'alert-danger'
        duration: '0'
    onMediaUploadStart: ->
      notify.closeAll()

    onMediaUploaded: (data) ->
      $scope.lecture.$externalMedia = undefined
      $scope.lecture.patch?(media: data, externalMedia: null)
      .then (newLecture)->
        # the backend
        $scope.lecture.media = data
        $scope.lecture.$mediaSource = [
          {
            src: $sce.trustAsResourceUrl($scope.lecture.media)
            type: 'video/mp4'
          }
        ]
        $scope.updateEditingProgress(newLecture)

    insertExternalVideo: ()->
      url = $scope.viewState.externalVideo
      result = switch true
        when /v.youku.com\/(.*)id_(.*).html/.test url
          # youku video http://v.youku.com/v_show/id_XODIwMDU0MDg0.html?f=23035007&ev=4&from=y1.3-idx-grid-1519-9909.86808-86807.7-1
          '<iframe height=498 width=510 src="http://player.youku.com/embed/' + url.replace(/.*id_(.*).html.*/,'$1') + '" frameborder=0 allowfullscreen></iframe>'
        when /v.qq.com\/cover(.*)vid=(.*)/.test url
          # qq video http://v.qq.com/cover/k/kd2yl4blio5xn17.html?vid=c0140yh6ew3
          '<iframe frameborder=0 src="http://v.qq.com/iframe/player.html?vid=' + url.replace(/.*vid=(.*)/,'$1') + '&tiny=0&auto=0" allowfullscreen></iframe>'
        when /^<iframe(.*)<\/iframe>*/.test url
          # iframe. TODO: Not safe, not sure if the content in iframe is a video.
          url
        else
          undefined
      if result
        $scope.lecture.externalMedia = result
        $scope.lecture.$externalMedia = $sce.trustAsHtml(result)
        $scope.lecture.patch?(externalMedia: result)
        .then (newLecture)->
          # the backend
          $scope.updateEditingProgress(newLecture)
      else
        notify
          message: '不支持该视频外链'
          classes: 'alert-danger'

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
    lecture.$externalMedia = $sce.trustAsHtml(lecture.externalMedia)
    $scope.lecture = lecture
    $scope.viewState.videoActive = lecture.media? || lecture.files.length == 0
    $scope.switchEdit() if lecture.__v == 0
    $scope.updateEditingProgress()
