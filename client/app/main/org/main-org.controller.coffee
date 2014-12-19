'use strict'

angular.module('budweiserApp')

# 有 org 的时候会用到这个 controller
.controller 'OrgMainCtrl', (
  $q
  Auth
  $modal
  $scope
  Restangular
) ->

  console.log 'OrgMainCtrl', $scope.org

  angular.extend $scope,
    Auth: Auth
    myCourses: null
    allCourses: null
    categories: null
    itemsPerPage: 6
    currentMyCoursesPage: 1
    maxSize: 3
    viewState:
      myCoursesFilters:
        category: null

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        size: 'lg'
        resolve:
          categories: -> $scope.categories
      .result.then (newCourse) ->
        $scope.myCourses.push newCourse

    loadMyCourses: ->
      Restangular.all('courses').getList()
      .then (courses) ->
        $scope.myCourses = courses

  loadCategories = ->
    Restangular.all('categories').getList()
    .then (categories) ->
      $scope.categories = categories

  loadAllCourses = ->
    Restangular.all('courses/public').getList()
    .then (result) ->
      classeQs = result.map (course) ->
        Restangular.all('classes').getList {courseId: course._id}
        .then (classes) ->
          course.$classes = classes
          course
      $q.all(classeQs)
    .then (result) ->
      $scope.allCourses = result

  loadAllCourses()
  loadCategories()
