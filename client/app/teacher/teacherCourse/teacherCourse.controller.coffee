'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $scope
  $state
  Navbar
  $rootScope
  Category
  Restangular
) ->

  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,

    deleteCallback: (course) ->
      Courses.splice(Courses.indexOf(course), 1)
      $state.go('main')

  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    console.log course
    $scope.course = course
    Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"

  Restangular.all('classes').getList courseId: $state.params.classeId
  .then (classes) ->
    $scope.classes = classes

  Category.find()
  .then (categories) ->
    $scope.categories = categories
