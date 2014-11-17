'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, (
  User
  Auth
  $http
  $state
  $scope
  $upload
  Courses
  $modal
  $localStorage
  CurrentUser
) ->

  angular.extend $scope,

    courses: undefined

    me: CurrentUser

    loadCourses: ()->
      $scope.courses = Courses

    startCourse: (event)->
      $state.go 'student.courseDetail', courseId: event.$course._id

    hideTimetable: false

    toggleHideTimetable: ()->
      $scope.hideTimetable = !$scope.hideTimetable
      $localStorage[$scope.me._id] ?= {}
      $localStorage[$scope.me._id].hideTimetable = $scope.hideTimetable

  $scope.hideTimetable = $localStorage[$scope.me._id]?.hideTimetable

  $scope.loadCourses()
