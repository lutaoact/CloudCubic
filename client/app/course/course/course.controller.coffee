'use strict'

angular.module('budweiserApp').controller 'CourseCtrl', (
  $q
  Auth
  $scope
  $state
  $rootScope
  Restangular
  notify
) ->

  if !$state.params.classeId
    return

  angular.extend $scope,
    me: null
    Auth: Auth
    $state: $state
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
