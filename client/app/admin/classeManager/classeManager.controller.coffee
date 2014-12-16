'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $state
  $scope
  Classes
  Restangular
  Courses
  $modal
) ->

  viewFirstClasse = ->
    classes = $scope.classes
    $scope.viewClasse(classes[0]) if classes.length > 0

  angular.extend $scope,
    classes: Classes
    other:
      _id: ''
      name: '未分班的学生'

    selectedClasse: null

    onCreateClasse: (classe) ->
      $scope.classes.push classe

    addClass: ()->
      $modal.open
        templateUrl: 'app/admin/classeManager/newClasseModal.html'
        controller: 'NewClasseModalCtrl'
        size: 'md'
        resolve:
          Courses: -> Courses
      .result.then (newClasse) ->
        $scope.classes.push newClasse
      true

    onDeleteClasses: (classes) ->
      angular.forEach classes, (c) ->
        $scope.classes.splice($scope.classes.indexOf(c), 1)
      viewFirstClasse() if $scope.classes.indexOf($scope.selectedClasse) == -1

    viewClasse: (classe) ->
      $state.go('admin.classeManager.detail', classeId:classe._id) if classe?

  $scope.$on '$stateChangeSuccess', (event, toState) ->
    viewFirstClasse() if toState.name == 'admin.classeManager'

  reloadStandAloneStudents = ->
    Restangular.all('users').getList(role:'student', standalone:true)
    .then (students) ->
      $scope.other.students = _.pluck students, '_id'
      $scope.other.$students = students

  reloadStandAloneStudents()
  $scope.$on 'reloadStandAloneStudents', reloadStandAloneStudents

  updateClassesStudents = (event, updateClasses) ->
    _.forEach updateClasses, (c) ->
      currentClasse = _.find Classes, _id:c._id
      currentClasse?.students = c.students
  $scope.$on 'removeUsersFromSystem', updateClassesStudents
