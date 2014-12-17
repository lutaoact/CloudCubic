'use strict'

angular.module('budweiserApp')

.directive 'courseList', ->
  restrict: 'E'
  replace: true
  controller: 'CourseListCtrl'
  templateUrl: 'app/course/course-list.html'
  scope:
    onCourseClick: '&'

.controller 'CourseListCtrl', ($scope, Auth, $modal, Restangular, $state,$q)->
  angular.extend $scope,
    selectCourse: (course)->
      $scope.selectedCourse = course
      $scope.onCourseClick()?(course)

    me: Auth.getCurrentUser

    loadCourses: ()->
      Restangular.all('courses/public').getList()
      .then (result)->
        classeQs = result.map (course)->
          Restangular.all('classes').getList {courseId: course._id}
          .then (classes)->
            course.$classes = classes
            course
        $q.all(classeQs)
      .then (result)->
        $scope.courses = result

    coursesFilter: (item)->
      switch $scope.viewState.filterMethod
        when 'all'
          return true
        when 'createdByMe'
          return item.postBy._id is $scope.me._id
      return true

  $scope.loadCourses()
