angular.module('budweiserApp')

.directive 'reports', ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/admin/organizationManager/reports.html'
  controller: 'ReportsCtrl'

.controller 'ReportsCtrl', (
  $scope
  $timeout
  Restangular
) ->
  angular.extend $scope,

    selectedDate: new Date()

    loading: true

    years: [2015..moment().year()]

    selectedYear: moment().year()

    months: [1..12]

    selectedMonth: moment().month() + 1

    viewState:
      mode: 'month'
      dateOptions:
        startingDay: 0
        "show-weeks":"false"
        'datepicker-mode':"month"
        'min-mode':"month"

    reset: ()->
      $scope.loadData()

    prevent: (event) ->
      event.preventDefault()
      event.stopPropagation()

    loadData: ()->
      $scope.loading = true
      $timeout ->
        $scope.loading = false
        $scope.studentAnalyses = [
            name: '小王'
            days: 10
            duration: 3*360000
          ,
            name: '小黑'
            days: 20
            duration: 3.4*360000
        ]
      , 1000

  $scope.loadData()


