'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider
  .state 'teacher.courseStats',
    url: '/courses/:courseId/stats'
    templateUrl: 'app/teacher/teacherCourseStats/teacherCourseStats.html'
    controller: 'TeacherCourseStatsCtrl'
    abstract: true

  .state 'teacher.courseStats.all',
    url: ''
    templateUrl:'app/teacher/teacherCourseStats/teacherCourseStats.all.html'
    controller: 'TeacherCourseStatsMainCtrl'
    roleRequired: 'teacher'

  .state 'teacher.courseStats.student',
    url: '/classes/:classeId/students/:studentId'
    templateUrl:'app/teacher/teacherCourseStats/teacherCourseStats.student.html'
    controller: 'TeacherCourseStatsStudentCtrl'
    roleRequired: 'teacher'

  .state 'teacher.courseStats.classe',
    url: '/classes/:classeId'
    templateUrl:'app/teacher/teacherCourseStats/teacherCourseStats.classe.html'
    controller: 'TeacherCourseStatsClasseCtrl'
    roleRequired: 'teacher'
