'use strict'

angular.module('budweiserApp')
.controller 'CalendarTileCtrl',
(
  $scope
  Restangular
  $state
  $filter
  Auth
  $modal
) ->
  # Use iso in chinese
  useIso = true

  weeksOfMonth = (date) ->
    selectedDay = date
    useIsoweek = useIso
    monthFirstDate = angular.copy(selectedDay).startOf('month')
    monthLastDate = angular.copy(selectedDay).endOf('month')
    if useIsoweek
      calendarMonthFirstDate = angular.copy(monthFirstDate).startOf('isoWeek')
      calendarMonthLastDate = angular.copy(monthLastDate).endOf('isoWeek')
    else
      calendarMonthFirstDate = angular.copy(monthFirstDate).startOf('week')
      calendarMonthLastDate = angular.copy(monthLastDate).endOf('week')
    calendarMonthDates = angular.copy(calendarMonthLastDate).diff(calendarMonthFirstDate,'days')
    calendarMonthWeeks = Math.ceil(calendarMonthDates / 7)
    weeks = []
    dateIndex = angular.copy(calendarMonthFirstDate)
    for i in [0..(calendarMonthWeeks-1)]
      week = []
      for j in [0..6]
        weekDay = {}
        day = angular.copy(dateIndex)
        dateIndex.add(1, 'days')
        weekDay.day = day
        weekDay.isInCurrentMonth = if day.month() is selectedDay.month() then true else false
        weekDay.isToday = if day.isSame(moment(), 'day') then true else false
        week.push weekDay
      weeks.push week
    return weeks


  angular.extend $scope,
    selectedDate: moment()

    today: moment()

    Auth: Auth

    coursesOfCurrentDate: []

    dayNames: if !useIso then ['日','一','二','三','四','五','六'] else ['一','二','三','四','五','六','日']

    weeks: weeksOfMonth(moment())

    dayClick: (weekDay, $event)->
      $scope.selectedDate = weekDay.day
      $scope.coursesOfCurrentDate = weekDay.events

      if !weekDay.isInCurrentMonth
        $scope.weeks = weeksOfMonth($scope.selectedDate)
        bindSchedules()

    prevClick: ()->
      $scope.selectedDate = moment($scope.selectedDate).add(-1, 'months')
      $scope.weeks = weeksOfMonth($scope.selectedDate)
      bindSchedules()

    nextClick: ()->
      $scope.selectedDate = moment($scope.selectedDate).add(1, 'months')
      $scope.weeks = weeksOfMonth($scope.selectedDate)
      bindSchedules()

    gotoCourse: (event)->

  Restangular.all('classes/schedules').getList()
  .then (schedules)->
    $scope.schedules = schedules
    bindSchedules()

  eventsOfDay = (day)->
    events = []
    if $scope.schedules?
      $scope.schedules.forEach (schedule)->
        if moment(schedule.start).diff(day,'days') > 0 or moment(schedule.until).diff(day,'days') < 0
          return
        else if moment(schedule.start).weekday() is day.weekday()
          event = {}
          event.title = schedule.course.name
          event.$course = schedule.course
          event.color = $filter('genColor')(schedule.course._id)
          event.startTime = moment(schedule.start).set('month',day.get('month')).set('date',day.get('date'))
          event.currentWeek = day.diff(moment(schedule.start),'weeks') + 1
          event.weeks = moment(schedule.until).diff(moment(schedule.start),'weeks') + 1
          event.endTime = moment(schedule.end).set('month',day.get('month')).set('date',day.get('date'))
          events.push event
        else
          return

    return events

  bindSchedules = ()->
    for week in $scope.weeks
      for day in week
        day.events = eventsOfDay(day.day, $scope.schedules)
        if day.day.isSame($scope.today, 'day')
          $scope.coursesOfCurrentDate = day.events
