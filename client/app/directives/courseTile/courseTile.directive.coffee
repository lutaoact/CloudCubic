'use strict'

angular.module('budweiserApp')

.directive 'courseTile', ($filter) ->
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
        lectures = $scope.course.lectureAssembly
        firstUndoLecture = _.find lectures, (lecture) ->
          $scope.progress?.indexOf(lecture._id) == -1
        firstUndoLecture = lectures[lectures.length - 1] if !firstUndoLecture?
        if firstUndoLecture?
          $state.go 'course.lecture',
            courseId  : $scope.course._id
            classeId  : $scope.classe._id
            lectureId : $filter('objectId')(firstUndoLecture)

    $scope.$watch Auth.getCurrentUser, (me) ->
      if me?.role is 'student'
        Restangular
        .all('progresses')
        .getList(
          courseId: $scope.course._id
          classeId: $scope.classe._id
        )
        .then (progress) ->
          lectures = $scope.course.lectureAssembly
          $scope.percentageCalculated = true
          $scope.progress = _.intersection(progress, lectures)
          $scope.percentage = ~~(100.0 * $scope.progress?.length / lectures.length)


.directive 'publicCourseTile', ->
  templateUrl: 'app/directives/courseTile/publicCourseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
    classe: '='
  link: (scope, element, attrs) ->
