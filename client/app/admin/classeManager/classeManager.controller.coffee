'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  $state
  $scope
  $modal
  Category
  Restangular
) ->

  angular.extend $scope,
    classes: null
    courses: Restangular.all('courses').getList()
    categories: Category.find().$object
    search:
      keyword: $state.params.keyword
      category: $state.params.category
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

    reload: (resetPage) ->
      $scope.pageConf.currentPage = 1 if resetPage
      $state.go('admin.classeManager', {
        category :$scope.search.category
        keyword  :$scope.search.keyword
        page     :$scope.pageConf.currentPage
      })

  $scope.$on 'classe.deleted', (event, classe)->
    $scope.classes.splice($scope.classes.indexOf(classe),1)
  
  Restangular
  .all('classes')
  .getList(
    from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit      : $scope.pageConf.itemsPerPage
    keyword    : $scope.search.keyword
    categoryId : $scope.search.category
    sort       : JSON.stringify {setTop : -1, created : -1}
  )
  .then (classes) ->
    console.log 'load classes: ', classes
    $scope.classes = classes


