'use strict'

angular.module('budweiserApp').controller 'StudentCourseHomeCtrl'
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
  Category
  CurrentUser
) ->

  Category.find()
  .then (categories)->
    $scope.categories = categories
    $scope.category = {name: '全部'}
    $scope.categories.unshift $scope.category

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
