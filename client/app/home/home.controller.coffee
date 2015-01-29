'use strict'

angular.module('budweiserApp')

.controller 'HomeCtrl', (
  Auth
  $modal
  $scope
  Restangular
) ->

  isStudent = -> Auth.getCurrentUser().role is 'student'

  angular.extend $scope,
    Auth: Auth
    myCourses: null
    myClasses: null
    categories: null
    itemsPerPage: if isStudent() then 6 else 5
    currentPage: 1
    maxSize: 3
    viewState:
      total: 0
      filterCategory: null

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        windowClass: 'new-course-modal'
        size: 'md'
        resolve:
          categories: -> $scope.categories
      .result.then (newCourse) ->
        $scope.currentPage = 1
        $scope.reload()

    getCourse: (data) ->
      if isStudent() then data.courseId else data

    getClasse: (data) ->
      if isStudent() then data else null

    getListData: ->
      if isStudent()
        $scope.myClasses
      else
        $scope.myCourses

    reload: () ->
      if isStudent()
        Restangular
        .all('classes')
        .getList
          studentId: Auth.getCurrentUser()._id
          categoryId: $scope.viewState.filterCategory?._id
          from: ($scope.currentPage - 1) * $scope.itemsPerPage
          limit: $scope.itemsPerPage
        .then (classes) ->
          $scope.myClasses = classes
      else
        Restangular
        .all('courses/me')
        .getList
          from: ($scope.currentPage - 1) * $scope.itemsPerPage
          limit: $scope.itemsPerPage
        .then (courses) ->
          $scope.myCourses = courses

  Restangular
  .all('categories')
  .getList()
  .then (categories) ->
    $scope.categories = categories

  $scope.$watch Auth.getCurrentUser, ->
    $scope.reload()
    .then (items) ->
      $scope.viewState.total = items.$count

