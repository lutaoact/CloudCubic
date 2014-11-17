'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  Auth
  $modal
  $state
  $scope
  Courses
  Categories
  $localStorage
  CurrentUser
) ->

  angular.extend $scope,

    courses: Courses

    me: CurrentUser

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        size: 'lg'
        resolve:
          categories: -> Categories
      .result.then (newCourse) ->
        $scope.courses.push newCourse

    startCourse : (event) ->
      $state.go 'teacher.course', courseId: event.$course._id

    hideTimetable: false

    toggleHideTimetable: ()->
      $scope.hideTimetable = !$scope.hideTimetable
      $localStorage[$scope.me._id] ?= {}
      $localStorage[$scope.me._id].hideTimetable = $scope.hideTimetable

  $scope.hideTimetable = $localStorage[$scope.me._id]?.hideTimetable
