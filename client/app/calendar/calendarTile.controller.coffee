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
      $scope.selectedDate = moment($scope.selectedDate).add('months', -1)
      $scope.weeks = weeksOfMonth($scope.selectedDate)
      bindSchedules()

    nextClick: ()->
      $scope.selectedDate = moment($scope.selectedDate).add('months', 1)
      $scope.weeks = weeksOfMonth($scope.selectedDate)
      bindSchedules()

    gotoCourse: (event)->
      if $state.includes 'student'
        $state.go 'courseDetail', courseId: event.$course._id
      else if $state.includes 'teacher'
        $state.go 'teacher.course', courseId: event.$course._id
      else
        console.log event

    addSchedule: ()->
      $modal.open
        templateUrl: 'app/directives/timetable/schedulePopup.html'
        controller: 'SchedulePopupCtrl'
      .result.then (schedules)->
        $scope.schedules.concat schedules
        bindSchedules()

    removeEvent: ($event, event)->
      $event.stopPropagation()
      event.schedule.remove()
      .then ->
        event.$container.splice event.$container.indexOf(event), 1

  (()->
    if Auth.getCurrentUser().role is 'student'
      Restangular.all('classes')
      .getList
        studentId: Auth.getCurrentUser()._id
    else
      Restangular.all('classes')
      .getList
        teacherId: Auth.getCurrentUser()._id
  )()
  .then (classes)->
    allSchedules = _.flatten(
      classes.map (classe)->
        classeCopy = angular.copy(classe)
        schedules = classe.schedules.map (schedule)->
          schedule.classe = classeCopy
          schedule.course = classeCopy.courseId
          schedule
        schedules
    )
    # Compose this week then set handle
    $scope.schedules = allSchedules
    console.log allSchedules
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
