'use strict'

angular.module('budweiserApp').directive 'classeTile', ()->
  templateUrl: 'app/teacher/teacherCourse/classe-tile.html'
  restrict: 'E'
  replace: true
  scope:
    classe: '='
    courses: '='
    plus: '@'
    onClasseDeleted: '&'

  controller: (
    Auth
    $scope
    $state
    $modal
    Restangular
  ) ->
    angular.extend $scope,
      Auth: Auth

      editClasse: (classe) ->
        $modal.open
          templateUrl: 'app/admin/classeManager/editClasseModal.html'
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

      viewClasse: (classe) ->
        if $scope.plus and Auth.hasRole('admin') and classe
          $state.go('admin.classeManager.detail', classeId:classe._id)

      deleteClasse: (classe)->
        $modal.open
          templateUrl: 'components/modal/messageModal.html'
          windowClass: 'message-modal'
          controller: 'MessageModalCtrl'
          size: 'sm'
          resolve:
            title: -> '删除班级'
            message: -> "确认要删除 #{classe.name}？"
        .result.then ->
          classe.remove()
        .then ->
          $scope.onClasseDeleted()?(classe)
