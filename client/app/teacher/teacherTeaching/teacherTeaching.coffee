'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.teaching',
    url: '/courses/:courseId/classes/lectures/:lectureId/teaching/:classeId'
    templateUrl: 'app/teacher/teacherTeaching/teacherTeaching.html'
    controller: 'TeacherTeachingCtrl'
    roleRequired: 'teacher'
    navClasses: 'hide'
