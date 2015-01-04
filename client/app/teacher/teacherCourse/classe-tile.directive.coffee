'use strict'

angular.module('budweiserApp').directive 'classeTile', ()->
  templateUrl: 'app/teacher/teacherCourse/classe-tile.html'
  restrict: 'E'
  replace: true
  scope:
    classe: '='
    plus: '@'

  controller: ($scope, Auth, $modal, $state)->
    angular.extend $scope,
      me: Auth.getCurrentUser

      editClasse: (classe)->
        $modal.open
          templateUrl: 'app/admin/classeManager/editClasseModal.html'
          controller: 'EditClasseModalCtrl'
          resolve:
            Classe: -> classe
            Courses: -> [$scope.courseId]
        .result.then (newClasse) ->

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
