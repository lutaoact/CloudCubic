'use strict'

angular.module('budweiserApp')

.controller 'MainCtrl', (org, Page, $scope) ->
  Page.setTitle '云立方学院 cloud3edu 提供教育云服务，教育的云计算时代，从云立方学院开始'

# 没 org 的时候会用到这个 controller
.controller 'DefaultMainCtrl', ($scope, $window, $timeout) ->

  angular.extend $scope,
    ios: '<div>ios</div>'
    distance: 800

  resize = -> $timeout ->
    $scope.distance = $window.innerHeight * 2 - 100

  resize()
  angular.element($window).bind 'resize', resize
  $scope.$on '$destroy', ->
    angular.element($window).unbind 'resize', resize

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

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        size: 'lg'
        resolve:
          categories: -> $scope.categories
      .result.then (newCourse) ->
        $scope.myCourses.push newCourse

  loadCategories = ->
    Restangular.all('categories').getList()
    .then (categories) ->
      $scope.categories = categories

  loadMyCourses = ->
    Restangular.all('courses').getList()
    .then (courses) ->
      $scope.myCourses = courses

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

  loadMyCourses() if Auth.isLoggedIn()
  loadAllCourses()
