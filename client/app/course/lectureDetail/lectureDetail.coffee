'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'course.lectureDetail',
    url: '/courses/:courseId/lectures/:lectureId'
    templateUrl: 'app/course/lectureDetail/lectureDetail.html'
    controller: 'LectureDetailCtrl'
