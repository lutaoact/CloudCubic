'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $scope
  $state
  Navbar
  $rootScope
  Category
  Restangular
  notify
) ->

  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,

    deleteCallback: (course) ->
      Courses.splice(Courses.indexOf(course), 1)
      $state.go('main')

    togglePublish: ($event)->
      $event.stopPropagation()
      Restangular.one('courses', $scope.course._id).patch isPublished: !$scope.course.isPublished
      .then ->
        $scope.course.isPublished = !$scope.course.isPublished

    saveCourseDesc: ()->
      Restangular.one('courses', $scope.course._id).patch description: $scope.course.description
      .then ->
        notify
          message:'已保存'
          classes: 'alert-success'

  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    $scope.course = course
    Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"

  Restangular.all('classes').getList courseId: $state.params.classeId
  .then (classes) ->
    $scope.classes = classes

  Category.find()
  .then (categories) ->
    $scope.categories = categories
