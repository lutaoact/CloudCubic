'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.questionLibrary',
    url: '/course/:courseId/question-library'
    templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionLibrary.html'
    controller: 'TeacherQuestionLibraryCtrl'
    roleRequired: 'teacher'
    resolve:
      KeyPoints: (Restangular) ->
        Restangular.all('key_points').getList().then (keyPoints) ->
          keyPoints
        , -> []
