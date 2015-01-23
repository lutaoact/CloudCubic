'use strict'

angular.module('budweiserApp').directive 'classeTile', ()->
  templateUrl: 'app/teacher/teacherCourse/classe-tile.html'
  restrict: 'E'
  replace: true
  scope:
    classe: '='
    courses: '='
    onClasseDeleted: '&'

  controller: (
    Auth
    $scope
    $state
    $modal
    Restangular
    messageModal
  ) ->
    angular.extend $scope,
      Auth: Auth

      editClasse: (classe) ->
        $modal.open
          templateUrl: 'app/classeManager/editClasseModal.html'
          controller: 'EditClasseModalCtrl'
          windowClass: 'edit-classe-modal'
          resolve:
            Courses: -> $scope.courses
            Classe: ->
              editingClasse = angular.copy(classe)
              editingClasse.courseId = editingClasse.courseId?._id ? editingClasse.courseId
              editingClasse
            Teachers: -> Restangular.all('users').getList(role:'teacher')
        .result.then (newClasse) ->
          angular.extend classe, newClasse

      switchSetTop: (classe) ->
        setTop = if classe.setTop then null else new Date()
        Restangular
        .one('classes', classe._id)
        .patch setTop:setTop
        .then (newClasse) ->
          angular.extend classe, newClasse

      deleteClasse: (classe)->
        messageModal.open
          title: -> '删除班级'
          message: -> "确认要删除 #{classe.name}？"
        .result.then ->
          classe.remove()
        .then ->
          $scope.onClasseDeleted()?(classe)
