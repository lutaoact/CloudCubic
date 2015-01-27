angular.module('budweiserApp')

.directive 'classeReport', ->
  restrict: 'EA'
  replace: true
  scope:
    month: '@'
  templateUrl: 'app/admin/reporting/classe-report.html'
  controller: 'ClasseReportCtrl'

.controller 'ClasseReportCtrl', (
  $scope
  $timeout
  Restangular
) ->
  angular.extend $scope,

    format: 'YYYY年MM月'

    itemsPerPage: 50
    currentPage: 1
    maxSize: 5

    prevent: (event) ->
      event.preventDefault()
      event.stopPropagation()

    loadData: ()->
      $scope.classeAnalyses = undefined
      selectedMonth = moment($scope.month, $scope.format)
      Restangular.all('active_times').getList {from: selectedMonth.clone().set('date', 1).format(),to:selectedMonth.clone().add(1,'months').set('date', 1).add(-1, 'days').format()}
      .then (data)->
        $scope.classeAnalyses = [
            classe:
              name: '物理强化班'
            price: 200
            amount: 321
          ,
            classe:
              name: '化学强化班'
            price: 190
            amount: 321
          ,
            classe:
              name: '数学强化班'
            price: 100
            amount: 521
          ,
            classe:
              name: '英语强化班'
            price: 123
            amount: 121
        ]

  $scope.$watch 'month', (value)->
    if value
      $scope.loadData()


