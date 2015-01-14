'use strict'

angular.module 'budweiserApp'

.directive 'lectureFilesEditor', ->
  restrict: 'EA'
  replace: true
  controller: 'LectureFilesEditorCtrl'
  templateUrl: 'app/teacher/teacherLecture/lectureFilesEditor.html'
  scope:
    lecture: '='
    onUpdate: '&'

.controller 'LectureFilesEditorCtrl', (
  $scope
  notify
  configs
  $filter
  $window
  $timeout
  Restangular
  messageModal
) ->

  angular.extend $scope,
    fileSizeLimitation: configs.fileSizeLimitation

    selectedFile: null
    fileViewer:
      slideListToggled: true
      slideActiveIndex: 0

    removeSlide: (index) ->
      messageModal.open
        title: -> '删除讲义页面'
        message: -> """确认要删除"#{$scope.lecture.name}"中讲义的第#{index+1}页？"""
      .result.then ->
        $scope.selectedFile.fileContent.splice(index, 1)
        Restangular.one('lectures', $scope.lecture._id)
        .patch?(files: $scope.lecture.files)
        .then (lecture) -> $scope.onUpdate?($lecture:lecture)

    sortSlides: ->
      Restangular.one('lectures', $scope.lecture._id)
      .patch?(files:$scope.lecture.files)
      .then (lecture) -> $scope.onUpdate?($lecture:lecture)
    removeFile: ->
      messageModal.open
        title: -> '删除课时讲义'
        message: -> """确认要删除"#{$scope.lecture.name}"的讲义？"""
      .result.then ->
        index = $scope.lecture.files.indexOf($scope.selectedFile)
        $scope.lecture.files.splice(index, 1)
        $scope.switchFile $scope.lecture.files[0]
        Restangular.one('lectures', $scope.lecture._id)
        .patch?(files: $scope.lecture.files)
        .then (lecture) -> $scope.onUpdate?($lecture:lecture)
    onError: (error) ->
      notify
        message: '上传失败：' + error
        classes: 'alert-danger'
    onFileUploadStart: ->
      $scope.fileUploadState = null
      $scope.fileUploadProgress = 0
      $scope.fileUploadInfo = ''
    onFileUploading: (speed, progress, event) ->
      $scope.fileUploadState = 'uploading'
      $scope.fileUploadProgress = progress
      $scope.fileUploadInfo = "上传率" + $filter('bytes')(event.loaded) + "/" + $filter('bytes')(event.total)
    onFileConverting: ->
      $scope.fileUploadState = 'converting'
      $scope.fileUploadProgress = 100
      $scope.fileUploadInfo = ''
    onFileUploaded: (data, replace = false) ->
      $scope.fileUploadState = null
      $scope.fileUploadProgress = null
      $scope.fileUploadInfo = ''
      if replace
        angular.extend $scope.selectedFile, data
      else
        $scope.lecture.files.push data
        $scope.switchFile(data)
      Restangular.one('lectures', $scope.lecture._id)
      .patch?(files: $scope.lecture.files)
      .then (lecture) -> $scope.onUpdate?($lecture:lecture)
    switchFile: (file) ->
      $scope.selectedFile = file
    getViewerHeight: ->
      $('#lecture-file-content').width() * $scope.selectedFile.fileHeight / $scope.selectedFile.fileWidth

  $scope.$watch 'lecture', (lecture) ->
    $scope.switchFile lecture?.files[0]
