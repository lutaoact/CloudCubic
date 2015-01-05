'use strict'

angular.module('budweiserApp').directive 'classeTile', ()->
  templateUrl: 'app/teacher/teacherCourse/classe-tile.html'
  restrict: 'E'
  replace: true
  scope:
    classe: '='
    plus: '@'

  controller: ($scope, $state, Auth, $modal, Restangular)->
    angular.extend $scope,
      me: Auth.getCurrentUser

      editClasse: (classe)->
        $modal.open
          templateUrl: 'app/admin/classeManager/editClasseModal.html'
          controller: 'EditClasseModalCtrl'
          resolve:
            Courses: -> [$scope.classe.courseId]
            Classe: -> angular.copy(classe)
            Teachers: -> Restangular.all('users').getList(role:'teacher')
        .result.then (newClasse) ->
          angular.extend classe, newClasse

      deleteCallback: (classe) ->
        $scope.$emit 'classe.deleted', classe

      viewClasse: (classe) ->
        if $scope.plus and Auth.hasRole('admin') and classe
          $state.go('admin.classeManager.detail', classeId:classe._id)

      deleteClasse: (classe)->
        $modal.open
          templateUrl: 'components/modal/messageModal.html'
          controller: 'MessageModalCtrl'
          resolve:
            title: -> '删除讨论组'
            message: -> "确认要删除《#{classe.name}》？"
        .result.then ->
          console.log classe
          classe.remove()
        .then ->
          $scope.deleteCallback?(classe)
