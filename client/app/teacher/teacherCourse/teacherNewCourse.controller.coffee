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

    setCategory: (category, input) ->
      if category?
        $scope.course.categoryId = category._id
        return
      if input?
        Restangular
          .all('categories')
          .post(name: input)
          .then (newCategory) ->
            categories.push newCategory
            $scope.course.categoryId = newCategory._id

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
