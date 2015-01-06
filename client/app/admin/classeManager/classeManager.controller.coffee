'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $state
  $scope
  $modal
  Restangular
) ->

  angular.extend $scope,
    classes: null
    courses: Restangular.all('courses').getList()
    search:
      keyword: $state.params.keyword
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 9

    createNewClasse: ->
      $modal.open
        templateUrl: 'app/admin/classeManager/editClasseModal.html'
        controller: 'EditClasseModalCtrl'
        windowClass: 'edit-classe-modal'
        resolve:
          Courses: -> $scope.courses
          Teachers: ->
            Restangular.all('users').getList(role: 'teacher')
          Classe: ->
            name: ''
            price: 0
            enrollment: {}
            duration: {}
      .result.then (newClasse) ->
        $scope.classes.splice 0, 0, newClasse

    setKeyword: ->
      $scope.pageConf.currentPage = 1
      $scope.reload()

    reload: ->
      $state.go('admin.classeManager', {
        keyword:$scope.search.keyword
        page:$scope.pageConf.currentPage
      })

  Restangular
  .all('classes')
  .getList(
    from    : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit   : $scope.pageConf.itemsPerPage
    keyword : $scope.search.keyword
  )
  .then (classes) ->
    console.log 'load classes: ', classes
    $scope.classes = classes
