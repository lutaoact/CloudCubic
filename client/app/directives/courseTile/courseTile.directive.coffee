'use strict'

angular.module('budweiserApp')

.directive 'courseTile', ->
  templateUrl: 'app/directives/courseTile/courseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
    classe: '='

  controller: ($scope, $state, Restangular, Auth) ->

    angular.extend $scope,
      Auth: Auth
      continueStudying: ($event) ->
        $event.stopPropagation()
        if !$scope.progress?.length and $scope.course.lectureAssembly.length
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

    $scope.$watch 'course', (value) ->
      if value and Auth.hasRole('student') and !Auth.hasRole('teacher')
        Restangular
        .all('progresses')
        .getList({courseId: value._id})
        .then (progress)->
          $scope.percentageCalculated = true
          $scope.progress = progress
          $scope.percentage = ~~(100.0 * _.intersection(progress, value.lectureAssembly)?.length / value.lectureAssembly.length)


.directive 'publicCourseTile', ->
  templateUrl: 'app/directives/courseTile/publicCourseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
    classe: '='
  link: (scope, element, attrs) ->
