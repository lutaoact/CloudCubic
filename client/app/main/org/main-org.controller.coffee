'use strict'

angular.module('budweiserApp')

# 有 org 的时候会用到这个 controller
.controller 'OrgMainCtrl', (
  $q
  Auth
  $modal
  $scope
  Restangular
  Category
) ->

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
        $q.all(_.uniq(_.pluck($scope.myCourses, 'categoryId')).map (id)->
          Category.find(id)
        )
        .then (categories)->
          $scope.myCategories = [{name:'全部'}].concat categories
          $scope.viewState.myCoursesFilters.category = $scope.myCategories[0]

  loadCategories = ->
    Category.find()
    .then (categories) ->
      $scope.categories = categories
      $scope.$categories = [{name:'全部'}].concat categories

  loadCategories()
