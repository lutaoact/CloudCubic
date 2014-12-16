'use strict'

angular.module('budweiserApp').controller 'CourseCtrl', (
  $q
  $scope
  $state
  Navbar
  Courses
  Category
  Restangular
) ->
  console.log Courses

  course = _.find Courses, _id:$state.params.courseId
  Restangular.all('classes').getList(courseId: $state.params.courseId)
  .then (classes)->
    course.$classes = classes

  Navbar.setTitle course.name, "course({courseId:'#{$state.params.courseId}'})"
  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,
    itemsPerPage: 10
    currentPage: 1
    course: course

    loadLectures: ()->
      if $state.params.courseId
        Restangular.all('lectures/public').getList({courseId: $state.params.courseId})
        .then (lectures)->
          $scope.course.$lectures = lectures
          $scope.course.$lectures
      else
        $q([])

  # $scope.loadLectures()
