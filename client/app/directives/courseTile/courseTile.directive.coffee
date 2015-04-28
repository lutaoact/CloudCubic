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
        # 找到第一个需要学习的课时（找到第一个没有在progress里面的课时）
        lectureToLearn = _.find lectures, (lecture) ->
          $scope.progress?.indexOf(lecture._id) == -1
        # 如果lecture都已经学习完（如果找不到需要学习的课时），定位到最后一个
        lectureToLearn = lectures[lectures.length - 1] if !lectureToLearn?
        if lectureToLearn?
          $state.go 'course.lecture',
            courseId  : $scope.course._id
            classeId  : $scope.classe._id
            lectureId : $filter('objectId')(lectureToLearn)

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
          # 移除不是这个课程的progress
          $scope.progress = _.intersection(progress, lectures)
          $scope.percentage = ~~(100.0 * $scope.progress?.length / lectures.length)
          $scope.percentageCalculated = true


.directive 'publicCourseTile', ->
  templateUrl: 'app/directives/courseTile/publicCourseTile.html'
  restrict: 'EA'
  replace: true
  scope:
    course: '='
    classe: '='
  link: (scope, element, attrs) ->
