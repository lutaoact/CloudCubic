'use strict'

angular.module('budweiserApp')

.controller 'TeacherNewCourseCtrl', (
  Auth
  $scope
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
      Restangular
      .all('courses')
      .post($scope.course)
      .then (newCourse) ->
        $modalInstance.close(newCourse)
