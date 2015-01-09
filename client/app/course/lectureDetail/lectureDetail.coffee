'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'course.lecture',
    url: '/lectures/:lectureId'
    templateUrl: 'app/course/lectureDetail/lectureDetail.html'
    controller: 'LectureDetailCtrl'
