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
      console.log $scope.selectedYear, $scope.selectedMonth
      $scope.loading = true
      $scope.studentAnalysesDict = undefined
      Restangular.all('active_times').getList {from: moment().set('year', $scope.selectedYear).set('month',$scope.selectedMonth-1).set('date', 1).format(),to:moment().set('year', $scope.selectedYear).set('month',$scope.selectedMonth).set('date', 1).add(-1, 'days').format()}
      .then (active_times)->
        studentAnalysesDict = {}
        active_times.forEach (active_time)->
          studentAnalysesDict[active_time.userId._id] ?= {days: 0, user: active_time.userId, duration: 0, raws: []}
          studentAnalysesDict[active_time.userId._id].days++
          studentAnalysesDict[active_time.userId._id].duration += active_time.activeTime
          studentAnalysesDict[active_time.userId._id].raws.push active_time
        $scope.studentAnalysesDict = studentAnalysesDict

  $scope.loadData()


