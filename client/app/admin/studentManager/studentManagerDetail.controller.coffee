'use strict'

angular.module('budweiserApp')

.controller 'StudentManagerDetailCtrl', (
  $state
  $scope
  chartUtils
  Restangular
  $q
) ->

  resetSelectedClasse = ->
    selectedClasse = _.find($scope.classes, _id:$scope.selectedClasse?._id) ? $scope.classes?[0]
    angular.extend $scope.selectedClasse, selectedClasse
    if selectedClasse?.students.length
      chartUtils.genStatsOnScope($scope, selectedClasse?.courseId?._id, selectedClasse._id)

  angular.extend $scope,
    $state: $state
    viewState: {}
    classes: null
    selectedClasse: {}

    updateStudent: ->
      $scope.reloadStudents()

    deleteStudent: ->
      $scope.reloadStudents()
      $state.go('admin.studentManager')

  promises = []

  promises.push(
    Restangular.one('users', $state.params.studentId).get()
    .then (student) ->
      $scope.student = student
  )
  promises.push(
    Restangular.all('classes').getList({studentId: $state.params.studentId,from: 0, limit: 1000})
    .then (classes) ->
      $scope.classes = classes.sort (x,y)->
        x.students.length < y.students.length
      resetSelectedClasse()
      $scope.classes
  )

  $q.all promises
  .then ()->
    $scope.classes.forEach (classe)->
      Restangular
      .all('progresses')
      .getList(
        userId: $scope.student._id
        courseId: classe.courseId._id
        classeId: classe._id
      )
      .then (progress) ->
        # 移除不是这个课程的progress
        classe.$finished = progress.length is classe.courseId.lectureAssembly.length
        classe.$progress = progress

  Restangular.all('orders').getList({userId: $state.params.studentId,from: 0, limit: 1000})
  .then (orders)->
    $scope.orders = orders
    paidOrders = orders.filter (order) -> order.status is 'succeed'
    if paidOrders.length
      $scope.totalPay = _.pluck(paidOrders, 'totalFee').reduce (pre, cur, index)->
        pre ?= 0
        pre += cur

  $scope.$watch 'selectedClasse._id', resetSelectedClasse

