'use strict'

angular.module('budweiserApp').directive 'courseTile', (Restangular)->
  templateUrl: 'app/directives/courseTile/courseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->
    scope.$watch 'course', (value)->
      if value
        Restangular.all('progresses').getList({courseId: value._id})
        .then (progress)->
          scope.percentageCalculated = true
          scope.progress = progress
          scope.percentage = ~~(100.0 * progress?.length / value.lectureAssembly.length)
  controller: ($scope, $state)->
    $scope.continueStudying = ($event)->
      $event.stopPropagation()
      if !$scope.progress?.length and $scope.lectureAssembly.length
        $state.go 'lectureDetail',
          courseId: $scope.course._id
          lectureId: $scope.course.lectureAssembly[0]
        return
      viewedLectures = $scope.course.lectureAssembly.filter (x)->
        $scope.progress.indexOf(x) > 0
      if viewedLectures and viewedLectures.length > 0
        # GOTO that course
        # TODO: last viewed should not be the last viewed item :(
        lastViewed = viewedLectures[viewedLectures.length - 1]
        $state.go 'lectureDetail',
          courseId: $scope.course._id
          lectureId: lastViewed


.directive 'publicCourseTile', ->
  templateUrl: 'app/directives/courseTile/publicCourseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
  link: (scope, element, attrs) ->
