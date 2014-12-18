'use strict'

angular.module('budweiserApp').controller 'CourseCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
  $location
) ->
  Restangular.all('courses').customGET("#{$state.params.courseId}/public")
  .then (course)->
    $scope.course = course
    Navbar.setTitle $scope.course.name, "course({courseId:'#{$state.params.courseId}'})"
    $scope.$on '$destroy', Navbar.resetTitle

  Restangular.all('classes').getList(courseId: $state.params.courseId)
  .then (classes)->
    $scope.classes = classes

  angular.extend $scope,
    itemsPerPage: 10
    currentPage: 1

    makeOrder: (classe)->
      Restangular.all('orders').post classes: [classe._id]
      .then (order)->
        $state.go 'order', orderId: order._id