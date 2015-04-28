'use strict'

angular.module('budweiserApp')

.directive 'editLectureQuestions', ->
  restrict: 'EA'
  replace: true
  controller: 'EditLectureQuestionsCtrl'
  templateUrl: 'app/teacher/teacherLecture/editLectureQuestions.html'
  scope:
    lecture: '='
    questionType: '@'
    categoryId: '='
    keyPoints: '='
    onUpdate: '&'

.controller 'EditLectureQuestionsCtrl', (
  $scope
  $state
  $modal
  $timeout
  $document
  Restangular
  messageModal
) ->

  angular.extend $scope,
    selectedAll: false
    deleting: false

    getQuestions: ->
      $scope.lecture?[$scope.questionType]

    addLibraryQuestion: ->
      $state.go 'teacher.lecture.questionLibrary',
        courseId: $state.params.courseId
        lectureId: $state.params.lectureId
        questionType: $scope.questionType

    addNewQuestion: ->
      $modal.open
        templateUrl: 'app/teacher/teacherLecture/newQuestion.html'
        controller: 'NewQuestionCtrl'
        windowClass: 'new-question-modal'
        backdrop: 'static'
        resolve:
          keyPoints: -> $scope.keyPoints
          categoryId: -> $scope.categoryId._id||$scope.categoryId
      .result.then (question) ->
        Restangular.all('questions').post(question)
        .then (newQuestion) ->
          addQuestions [newQuestion]

    getSelectedNum: ->
      _.reduce $scope.getQuestions(), (sum, q) ->
        sum + (if q.$selected then 1 else 0)
      , 0

    toggleSelectAll: (selected) ->
      angular.forEach $scope.getQuestions(), (q) -> q.$selected = selected

    removeQuestion: (question = null) ->
      messageModal.open
        title: -> '删除问题'
        message: ->
          if question?
            """确认要删除这个问题？"""
          else
            """确认要删除这#{$scope.getSelectedNum()}个问题？"""
      .result.then ->
        questions = $scope.getQuestions()
        deleteQuestions =
          if question?
            [ question ]
          else
            $scope.selectedAll = false if $scope.selectedAll
            deleteQuestions = _.filter questions, (q) -> q.$selected == true
        angular.forEach deleteQuestions, (q) -> questions.splice(questions.indexOf(q), 1)
        $scope.deleting = true
        saveQuestions(questions)

  addQuestions = (newQuesions) ->
    questions = $scope.getQuestions()
    angular.forEach newQuesions, (q) -> questions.push q
    saveQuestions(questions)

  saveQuestions = (questions) ->
    patch = {}
    patch[$scope.questionType] = _.map questions, (q) -> q._id
    if $scope.lecture.patch?
      $scope.lecture.patch(patch)
      .then (newLecture) ->
        $scope.onUpdate?($lecture:newLecture)
        backToLecture()
    else
      _.delay backToLecture, 300

  backToLecture = ->
    $scope.deleting = false
    $state.go 'teacher.lecture',
      courseId: $state.params.courseId
      lectureId: $state.params.lectureId

  $scope.$on 'add-library-question', (event, type, questions) ->
    if type isnt $scope.questionType then return
    addQuestions questions
    finish = $scope.$on '$stateChangeSuccess', -> $timeout ->
      finish()
      targetElement = angular.element(document.getElementById 'lecture-question')
      $document.scrollToElement(targetElement, 60, 500)
