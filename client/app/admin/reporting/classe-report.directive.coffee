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

    loading: true

    loadData: ()->
      @loading = true
      $scope.classeAnalyses = null
      selectedMonth = moment($scope.month, $scope.format)
      Restangular.all('orders/report').getList {from: selectedMonth.clone().set('date', 1).format(),to:selectedMonth.clone().add(1,'months').set('date', 1).add(-1, 'days').format()}
      .then (data)->
        $scope.loading = false
        $scope.classeAnalyses = data

  $scope.$watch 'month', (value)->
    if value
      $scope.loadData()


