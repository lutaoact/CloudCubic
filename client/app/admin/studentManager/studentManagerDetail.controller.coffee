'use strict'

angular.module('budweiserApp')

.controller 'StudentManagerDetailCtrl', (
  $state
  $scope
  chartUtils
  Restangular
  $q
  org
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


  format = 'YYYY年MM月'
  $scope.startMonth = moment(org.created)

  $scope.months = [0..moment().diff($scope.startMonth.clone(), 'months')+1].map (num)->
    $scope.startMonth.clone().add(num, 'months').format(format)
  .reverse()

  $scope.getActiveTimes = (month)->
    selectedMonth = moment(month, format)
    $scope.viewState.selectedMonth = month
    $scope.display = selectedMonth
    Restangular.all('active_times').getList {from: selectedMonth.clone().set('date', 1).format(),to:selectedMonth.clone().add(1,'months').set('date', 1).add(-1, 'days').format(), userId:$state.params.studentId}
    .then (active_times)->
      trendChart =
        options:
          # hide legend
          legend:
            enabled: false
          chart:
            type: 'area'
            zoomType: 'x'
            height: 200
          # Hide watermark
          credits:
            enabled: false

          plotOptions:
            series:
              color: '#E6505F'
              fillOpacity: 0.1
              dataLabels:
                enabled: true
                format: '{y}'
          tooltip:
            useHTML: true
            headerFormat: ''
            pointFormat: '{point.name}: {point.y:.1f}小时'
        series: [
        ]
        xAxis:
          title:
            text: '日期'
          tickInterval: 2
        yAxis:
          title:
            text: '时长(小时)'
          max: 12
          min: 0
          tickInterval: 2
          gridLineDashStyle: 'longdash'
        title:
          text: null
      trendChart.series = [
        {
          data: [1..selectedMonth.clone().add(1,'months').set('date', 1).add(-1, 'days').get('date')].map (date, index)->
            activeTime = (active_times.filter (x) ->
              (new Date(x.date).getDate()) is date
            )?[0]?.activeTime || 0
            name: selectedMonth.get('month')+'月'+date+'日'
            y: activeTime / 60
          pointStart: 1
        }
      ]
      $scope.loginActivitiesChart = trendChart

  $scope.getActiveTimes(moment().format(format))

  $scope.$watch 'selectedClasse._id', resetSelectedClasse

