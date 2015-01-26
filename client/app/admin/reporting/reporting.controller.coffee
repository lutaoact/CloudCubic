'use strict'

angular.module('budweiserApp').controller 'ReportingCtrl', (
  $modal
  $scope
  $state
  Restangular
) ->

  format = 'YYYY年MM月'

  angular.extend $scope,
    viewState: {}
    menu: [
        title: '用户活跃度'
        type: 'active_time'
      ,
        title: '班级购买率'
        type: 'classes'
    ]
    format: format
    startMonth: moment().set('year', 2014).set('month',0)
    pageConf:
      month: $state.params.month or moment().format(format)
      type: $state.params.type or 'active_time'

    reset: ()->
      $state.go 'admin.reporting',
        month: $scope.pageConf.month
        type: $scope.pageConf.type

  $scope.months = [0..moment().diff($scope.startMonth.clone(), 'months')].map (num)->
    $scope.startMonth.clone().add(num, 'months').format(format)
  .reverse()

  $scope.$on 'reporting.active_times', (event, data)->
    $scope.viewState.daysSum = data[0]
    $scope.viewState.durationSum = data[1]


