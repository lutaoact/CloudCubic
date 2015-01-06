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

  generateCategories = ->
    $q.all(_.uniq(_.pluck(_.pluck($scope.myCourses, 'categoryId').filter((x)-> x?),'_id')).map (id)->
      if id
        Category.find(id)
      else
        null
    )
    .then (categories)->
      categories = categories.filter (category)->
        category?
      $scope.myCategories = [{name:'全部'}].concat(categories)
      $scope.viewState.myCoursesFilters.category = $scope.myCategories[0]

  if isClasseData()
    Restangular
    .all('classes')
    .getList(studentId: Auth.getCurrentUser()._id)
    .then (classes) ->
      console.log 'myClasses', classes
      $scope.myClasses = classes
  else
    Restangular
    .all('courses/me')
    .getList()
    .then (courses) ->
      $scope.myCourses = courses
      generateCategories()
