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
    other:
      _id: ''
      name: '未分班的学生'

    selectedClasse: null

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
          # FIXME course 分页？
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

    deleteClasse: (classe) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        size: 'sm'
        resolve:
          title: -> "删除班级"
          message: ->
            """确认要删除班级"#{classe.name}"吗？"""
      .result.then ->
        Restangular
        .one('classes', classe._id)
        .remove()
        .then ->
          index = $scope.classes.indexOf(classe)
          $scope.classes.splice(index, 1)

    setKeyword: ($event) ->
      if $event.keyCode isnt 13 then return
      $scope.pageConf.currentPage = 1
      $scope.reload()

    reload: ->
      $state.go('admin.classeManager', {keyword:$scope.search.keyword, page:$scope.pageConf.currentPage})

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

  Restangular
  .all('classes')
  .getList(
    from    : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit   : $scope.pageConf.itemsPerPage
    keyword : $scope.search.keyword
  )
  .then (classes) ->
    $scope.classes = classes
