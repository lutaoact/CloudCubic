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

    prevent: (event) ->
      event.preventDefault()
      event.stopPropagation()

    loadData: ()->
      selectedMonth = moment($scope.month, $scope.format)
      Restangular.all('active_times').getList {from: selectedMonth.clone().set('date', 1).format(),to:selectedMonth.clone().add(1,'months').set('date', 1).add(-1, 'days').format()}

  $scope.$watch 'month', (value)->
    if value
      $scope.loadData()


