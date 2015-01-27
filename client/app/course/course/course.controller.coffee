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
    me: null
    Auth: Auth
    progress: null

    loadProgress: ->
      $scope.progress = null

      if !Auth.isLoggedIn() then return
      me = $scope.me
      isAdmin   = me?.role is 'admin'
      isOwner   = _.find($scope.course?.owners, _id:me?._id)
      isTeacher = _.find($scope.classe?.teachers, _id: me?._id)
      isLearner = $scope.classe?.students?.indexOf(me?._id) != -1

      if isAdmin or isOwner or isTeacher or isLearner
        Restangular
        .all('progresses')
        .getList(
          courseId: $state.params.courseId
          classeId: $state.params.classeId
        )
        .then (progress) ->
          # 移除不是这个课程的progress
          $scope.progress = _.intersection(progress, _.pluck($scope.course.lectureAssembly, '_id'))

    courseQ: Restangular.one('courses', $state.params.courseId).get()

    classeQ: Restangular.one('classes',$state.params.classeId).get()

  # 获取该课程的基本信息
  $scope.courseQ
  .then (course) ->
    $scope.course = course

  # 获取班级信息
  $scope.classeQ
  .then (classe) ->
    $scope.classe = classe

  $scope.$watch Auth.getCurrentUser, (me) ->
    $scope.me = me
    $q.all [
      $scope.classeQ
      $scope.courseQ
    ]
    .then $scope.loadProgress
