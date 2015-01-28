angular.module('budweiserApp')

.directive 'userReport', ->
  restrict: 'EA'
  replace: true
  scope:
    month: '@'
  templateUrl: 'app/admin/reporting/user-report.html'
  controller: 'UserReportCtrl'

.controller 'UserReportCtrl', (
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
      $scope.studentAnalyses = null
      $scope.loading = true
      selectedMonth = moment($scope.month, $scope.format)
      $scope.display = selectedMonth.format('MM月')
      Restangular.all('active_times').getList {from: selectedMonth.clone().set('date', 1).format(),to:selectedMonth.clone().add(1,'months').set('date', 1).add(-1, 'days').format()}
      .then (active_times)->
        $scope.loading = false
        studentAnalysesDict = {}
        daysSum = 0
        durationSum = 0
        active_times.forEach (active_time)->
          studentAnalysesDict[active_time.userId._id] ?= {days: 0, user: active_time.userId, duration: 0, raws: []}
          studentAnalysesDict[active_time.userId._id].days++
          daysSum++
          durationSum += active_time.activeTime
          studentAnalysesDict[active_time.userId._id].duration += active_time.activeTime
          studentAnalysesDict[active_time.userId._id].raws.push active_time
        $scope.studentAnalyses = _.values studentAnalysesDict
        $scope.$emit 'reporting.active_times', [daysSum, durationSum]

  $scope.$watch 'month', (value)->
    if value
      $scope.loadData()


