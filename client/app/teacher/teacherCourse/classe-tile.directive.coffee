'use strict'

angular.module('budweiserApp').directive 'classeTile', ()->
  templateUrl: 'app/teacher/teacherCourse/classe-tile.html'
  restrict: 'E'
  replace: true
  scope:
    classe: '='
    course: '='

  controller: ($scope, Auth, $modal)->
    angular.extend $scope,
      me: Auth.getCurrentUser

      editClasse: (classe)->
        classe.$course = $scope.course
        $modal.open
          templateUrl: 'app/admin/classeManager/editClasseModal.html'
          controller: 'EditClasseModalCtrl'
          resolve:
            Classe: -> classe
            Courses: -> [$scope.course]
        .result.then (newClasse) ->

      deleteCallback: (classe) ->
        $scope.$emit 'classe.deleted', classe

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
