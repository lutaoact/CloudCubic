'use strict'

angular.module('budweiserApp')

# 有 org 的时候会用到这个 controller
.controller 'HomeCtrl', (
  $q
  Auth
  $modal
  $scope
  Category
  Restangular
) ->

  isClasseData = -> Auth.getCurrentUser().role is 'student'

  angular.extend $scope,
    Auth: Auth
    myCourses: null
    myClasses: null
    itemsPerPage: 6
    currentMyCoursesPage: 1
    maxSize: 3
    viewState:
      total: 0
      myCoursesFilters:
        category: null

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        size: 'lg'
        resolve:
          categories: -> Category.find()
      .result.then (newCourse) ->
        $scope.myCourses.push newCourse

    getCourse: (data) ->
      if isClasseData() then data.courseId else data

    getClasse: (data) ->
      if isClasseData() then data else null

    getListData: ->
      if isClasseData()
        $scope.myClasses
      else
        $scope.myCourses

    reload: () ->
      if isClasseData()
        Restangular
        .all('classes')
        .getList
          studentId: Auth.getCurrentUser()._id
          categoryId: $scope.viewState.myCoursesFilters.category?._id
          from: ($scope.currentMyCoursesPage - 1) * $scope.itemsPerPage
          limit: $scope.itemsPerPage
        .then (classes) ->
          $scope.myClasses = classes
      else
        Restangular
        .all('courses/me')
        .getList
          from: ($scope.currentMyCoursesPage - 1) * $scope.itemsPerPage
          limit: $scope.itemsPerPage
        .then (courses) ->
          $scope.myCourses = courses

  Category.find()
  .then (categories)->
    $scope.myCategories = [{name:'全部'}].concat(categories)
    $scope.viewState.myCoursesFilters.category = $scope.myCategories[0]
    $scope.reload()
    .then (items)->
      # at the first time get the total number.
      $scope.viewState.total = items.$count

