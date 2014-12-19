'use strict'

angular.module('budweiserApp')
.controller 'CalendarPopupCtrl',
(
  $scope
  Restangular
  $state
  $filter
  $modalInstance
) ->

  weeksOfMonth = (date, useIsoweek) ->
    selectedDay = date
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
        dateIndex.add('days', 1)
        weekDay.day = day
        weekDay.isInCurrentMonth = if day.month() is selectedDay.month() then true else false
        weekDay.isToday = if day.isSame(moment(), 'day') then true else false
        week.push weekDay
      weeks.push week
    return weeks

  angular.extend $scope,
    selectedDate: moment()

    today: moment()

    coursesOfCurrentDate: []

    dayNames: ['周日','周一','周二','周三','周四','周五','周六']

    weeks: weeksOfMonth(moment(), false)

    dayClick: (weekDay, $event)->
      $scope.selectedDate = weekDay.day
      $scope.coursesOfCurrentDate = weekDay.events

      if !weekDay.isInCurrentMonth
        $scope.weeks = weeksOfMonth($scope.selectedDate, false)
        bindSchedules()

    prevClick: ()->
      $scope.selectedDate = moment($scope.selectedDate).add('months', -1)
      $scope.weeks = weeksOfMonth($scope.selectedDate, false)
      bindSchedules()

    nextClick: ()->
      $scope.selectedDate = moment($scope.selectedDate).add('months', 1)
      $scope.weeks = weeksOfMonth($scope.selectedDate, false)
      bindSchedules()

    gotoCourse: (event)->

      if $state.includes 'student'
        $state.go 'course.detail', courseId: event.$course._id
      else if $state.includes 'teacher'
        $state.go 'teacher.course', courseId: event.$course._id
      else
        console.log event
      $modalInstance.dismiss('close')

  Restangular.all('schedules').getList()
  .then (schedules)->
    # Compose this week then set handle
    $scope.schedules = schedules

    bindSchedules()

  eventsOfDay = (day)->
    events = []
    if $scope.schedules?
      $scope.schedules.forEach (schedule)->
        if moment(schedule.start).isAfter day or moment(schedule.until).isBefore day
          return
        else
          event = {}
          event.title = schedule.course.name
          event.$course = schedule.course
          event.color = $filter('genColor')(schedule.course._id)
          event.startTime = moment(schedule.start).weeks(day.weeks())
          event.currentWeek = day.diff(moment(schedule.start),'weeks') + 1
          event.weeks = moment(schedule.until).diff(moment(schedule.start),'weeks') + 1
          event.endTime = moment(schedule.end).weeks(day.weeks())
          events.push event

    return events

  bindSchedules = ()->
    for week in $scope.weeks
      for day in week
        day.events = eventsOfDay(day.day, $scope.schedules)
        if day.day.isSame($scope.today, 'day')
          $scope.coursesOfCurrentDate = day.events
