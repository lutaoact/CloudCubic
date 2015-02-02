'use strict'

angular.module('budweiserApp')

.controller 'TeacherNewCourseCtrl', (
  Auth
  $scope
  $state
  configs
  categories
  Restangular
  $modalInstance
) ->

  angular.extend $scope,

    imageSizeLimitation: configs.imageSizeLimitation

    categories: categories

    course:
      owners: [Auth.getCurrentUser()]

    onThumbUploaded: (key) ->
      $scope.course.thumbnail = key

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      unless form.$valid then return
      $scope.course.thumbnail or= '/assets/images/course-default.jpg'
      Restangular
      .all('courses')
      .post($scope.course)
      .then (newCourse) ->
        $modalInstance.close(newCourse)
        $state.go "teacher.course", courseId: newCourse._id
