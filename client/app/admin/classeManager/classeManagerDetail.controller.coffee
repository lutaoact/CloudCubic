'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerDetailCtrl', (
  $scope
  $state
  notify
  $modal
  Courses
  $rootScope
) ->

  angular.extend $scope,

    eidtingInfo: null

    editClasse: ->
      console.log 'editClasse', $scope.selectedClasse
      $modal.open
        templateUrl: 'app/admin/classeManager/editClasseModal.html'
        controller: 'EditClasseModalCtrl'
        resolve:
          Courses: -> Courses
          Classe: -> angular.copy($scope.selectedClasse)
      .result.then (classe) ->
        angular.extend $scope.selectedClasse, classe
        notify
          message: '开课班级信息修改成功'
          classes: 'alert-success'

    reloadStudents: (users, remove) ->
      if _.isEmpty($scope.selectedClasse._id) || remove == 1
        $rootScope.$broadcast 'reloadStandAloneStudents'

      $scope.selectedClasse?.all?('students').getList()
      .then (students) ->
        $scope.selectedClasse.students = _.pluck students, '_id'
        $scope.selectedClasse.$students = students

    viewStudent: (student) ->
      $state.go('admin.classeManager.detail.student', classeId:$scope.selectedClasse._id, studentId:student._id)

  $scope.$parent.selectedClasse = _.find($scope.classes, _id:$state.params.classeId) ? $scope.other
  $scope.reloadStudents()
