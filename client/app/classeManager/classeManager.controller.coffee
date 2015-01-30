'use strict'

angular.module('budweiserApp')

.controller 'ClasseManagerCtrl', (
  Auth
  $state
  $scope
  $modal
  Restangular
) ->

  angular.extend $scope,
    classes: null
    courses: Restangular.all('courses/me').getList()
    search:
      keyword  : $state.params.keyword
      course   : $state.params.course
    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 9

    createNewClasse: ->
      $modal.open
        templateUrl: 'app/classeManager/editClasseModal.html'
        controller: 'EditClasseModalCtrl'
        windowClass: 'edit-classe-modal'
        resolve:
          Courses: -> $scope.courses
          Teachers: ->
            Restangular.all('users').getList(role: 'teacher')
          Classe: ->
            name: ''
            price: 0
            teachers: []
            enrollment: {}
            duration: {}
      .result.then (newClasse) ->
        $scope.classes.splice 0, 0, newClasse

    setKeyword: ->
      $scope.pageConf.currentPage = 1
      $scope.reload()

    reload: (resetPage) ->
      $scope.pageConf.currentPage = 1 if resetPage
      $state.go 'classeManager',
        keyword  :$scope.search.keyword
        page     :$scope.pageConf.currentPage

    classDeleteCallback: (classe)->
      $scope.classes.splice($scope.classes.indexOf(classe),1)

  $scope.$watch Auth.getCurrentUser, (me) ->
    if !Auth.hasRole('teacher') then return
    Restangular
    .all('classes')
    .getList(
      from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
      limit      : $scope.pageConf.itemsPerPage
      keyword    : $scope.search.keyword
      courseId   : $scope.search.course
      teacherId  : if me.role is 'teacher' then me._id else null
      sort       : JSON.stringify {setTop : -1, created : -1}
    )
    .then (classes) ->
      $scope.classes = classes


