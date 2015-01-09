'use strict'

angular.module('budweiserApp').controller 'CourseCtrl', (
  $q
  Auth
  $scope
  $state
  Category
  $rootScope
  Restangular
  notify
) ->

  if !$state.params.classeId
    return

  angular.extend $scope,
    Auth: Auth

    loadProgress: ->
      $scope.viewedLectureIndex = 1
      if !$state.params.courseId or !Auth.isLoggedIn() then return
      Restangular.all('progresses').getList({courseId: $state.params.courseId})
      .then (progress)->
        progress?.forEach (lectureId)->
          viewedLecture = _.find $scope.course.lectureAssembly, _id: lectureId
          viewedLecture?.$viewed = true
          $scope.viewedLectureIndex = $scope.course.lectureAssembly.indexOf(viewedLecture) + 1 if $scope.viewedLectureIndex < $scope.course.lectureAssembly.indexOf(viewedLecture) + 1


  # 获取该课程的基本信息
  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    $scope.course = course
    $scope.loadProgress()

  # 获取班级信息
  Restangular.one('classes',$state.params.classeId).get()
  .then (classe)->
    $scope.classe = classe
  , (err)->
    console.log err
