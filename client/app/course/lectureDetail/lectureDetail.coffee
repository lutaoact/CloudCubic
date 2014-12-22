'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'lectureDetail',
    url: '/courses/:courseId/lectures/:lectureId'
    templateUrl: 'app/course/lectureDetail/lectureDetail.html'
    controller: 'LectureDetailCtrl'
