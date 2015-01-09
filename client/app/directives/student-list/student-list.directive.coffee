'use strict'

angular.module('budweiserApp').directive 'studentList', ->
  templateUrl: 'app/directives/student-list/student-list.html'
  replace: true
  restrict: 'E'
  scope:
    classes: '='
    selectedStudent: '='
    studentsStatus: '='
    onStudentSelect: '&'
    onClasseSelect: '&'
  link: (scope, element, attrs) ->

  controller: ($scope, $q, Restangular, $state)->
    angular.extend $scope,
      allStudentsDict: undefined
      allStudentsArray: []
      viewState: {}

      toggleClasse: (classe)->
        if @viewState.expandClasse == classe
          @viewState.expandClasse = undefined
        else
          @viewState.expandClasse = classe

      loadStudents: ->
        $q.all($scope.classes.map (classe)->
          Restangular.all("classes/#{classe._id}/students").getList()
          .then (students)->
            $scope.allStudentsArray = $scope.allStudentsArray.concat students
            students.forEach (student)->
              student.$classeInfo =
                id: classe._id
                name: classe.name
            classe.$students = students
        ).then ->
          $scope.allStudentsDict = _.indexBy $scope.allStudentsArray, '_id'
          updateStudentsStatus()

      selectStudent: (student)->
        $scope.selectedStudent = student
        $scope.selectedClass = null
        $scope.onStudentSelect($student:student)

      selectClasse: (classe) ->
        $scope.selectedClass = classe
        $scope.selectedStudent = null
        $scope.onClasseSelect($classe:classe)

    updateStudentsStatus = ()->
      if $scope.allStudentsDict? and $scope.studentsStatus
        $scope.studentsStatus.forEach (studentStatus)->
          $scope.allStudentsDict[studentStatus.id].$className = studentStatus.className

    $scope.$watch 'classes', (value) ->
      if value
        $scope.loadStudents()

    $scope.$watch 'allStudentsDict', (value)->
     if value and $state.params.studentId
       $scope.selectedStudent = value[$state.params.studentId]

    $scope.$watch 'studentsStatus', (value)->
      updateStudentsStatus()

