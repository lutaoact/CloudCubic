'use strict'

angular.module('budweiserApp').directive 'timetable', ($timeout)->
  templateUrl: 'app/directives/timetable/timetable.html'
  restrict: 'E'
  scope:
    eventClick: '&'
  controller: ($scope, $document, Auth, $modal, Restangular, timetableHelper)->

    angular.extend $scope,
      loadTimetable: ()->
        Restangular.all('schedules').getList()
        .then (schedules)->
          # Compose this week then set handle
          $scope.eventSouces = timetableHelper.genTimetable(schedules)
          $scope.schedules = schedules

      dayChangedHandle: (day)->
        if $scope.schedules
          $scope.eventSouces = timetableHelper.genTimetable($scope.schedules, moment(day))

      eventSouces: undefined

      onEventClick: ($event, event)->
        $scope.eventClick?()? event

      today: moment()

      selectedDay: moment()._d

      getWeek: ()->
        m = ('0' + (moment($scope.selectedDay).month() + 1)).substr(-2,2)
        startDate = ('0' + moment($scope.selectedDay).startOf('week').date()).substr(-2,2)
        endDate = ('0' + moment($scope.selectedDay).endOf('week').date()).substr(-2,2)
        "#{m}/#{startDate} - #{m}/#{endDate}"

      next: ()->
        @selectedDay = moment(@selectedDay).add(1, 'weeks')._d

      prev: ()->
        @selectedDay = moment(@selectedDay).subtract(1, 'weeks')._d

      $scope.$watch 'selectedDay', (value)->
        if value
          $scope.dayChangedHandle?(value)

      showAddBtn: ()->
        Auth.getCurrentUser().role is 'teacher'

      addSchedule: ()->
        $modal.open
          templateUrl: 'app/directives/timetable/schedulePopup.html'
          controller: 'SchedulePopupCtrl'
          resolve:
            courses: $scope.courses
        .result.then (schedule)->
          $scope.eventSouces = timetableHelper.genTimetable($scope.schedules)

    $scope.loadTimetable()

  link: (scope, element, attrs) ->
    # will be init after this.
    datepicker = undefined
    overlay = element.find('.overlay')
    calendarToggle = element.find('.calendar-toggle')
    overlay.hide()

    openPopupHandle = ()->
      overlay.unbind 'click', closePopupHandle
      datepicker ?= element.find('.datepicker')
      datepicker.fadeIn('fast')
      overlay.show()
      calendarToggle.addClass('active')
      overlay.bind 'click', closePopupHandle

    closePopupHandle = ()->
      datepicker ?= element.find('.datepicker')
      datepicker.fadeOut('fast')
      overlay.hide()
      calendarToggle.removeClass('active')
      overlay.unbind 'click', closePopupHandle

    calendarToggle.bind 'click', openPopupHandle

.factory 'timetableHelper', ($filter, Auth)->
  genStudentTimetable: (schedules, day)->
    eventSouces = [1..5].map -> []
    today = day or moment()
    weekStart = today.clone().startOf('isoWeek')
    weekEnd = today.clone().endOf('isoWeek')
    schedules.forEach (schedule)->
      if moment(schedule.start).isAfter(weekEnd) or moment(schedule.until).isBefore(weekStart)
        # not shown
        return
      else
        isoWeekday =  moment(schedule.start).isoWeekday() # 1,2...7
        event = {}
        event.title = schedule.course.name
        event.$course = schedule.course
        event.color = $filter('genColor')(schedule.course._id)
        event.startTime = moment(schedule.start).weeks(today.weeks())
        event.currentWeek = today.diff(moment(schedule.start),'weeks') + 1
        event.weeks = moment(schedule.until).diff(moment(schedule.start),'weeks') + 1
        event.endTime = moment(schedule.end).weeks(today.weeks())
        eventSouces[isoWeekday - 1].push event
    eventSouces

  genTeacherTimetable: (schedules, day)->
    eventSouces = [1..5].map -> []
    today = day or moment()
    weekStart = today.clone().startOf('isoWeek')
    weekEnd = today.clone().endOf('isoWeek')
    schedules.forEach (schedule)->
      if moment(schedule.start).isAfter(weekEnd) or moment(schedule.until).isBefore(weekStart)
        # not shown
        return
      else
        isoWeekday =  moment(schedule.start).isoWeekday() # 1,2...7
        event = {}
        event.title = schedule.course.name
        event.subtitle = [schedule.classe.yearGrade, schedule.classe.name].join(' ')
        event.$course = schedule.course
        event.startTime = moment(schedule.start).weeks(today.weeks())
        # event.currentWeek = today.diff(moment(schedule.start),'weeks') + 1
        # event.weeks = moment(schedule.until).diff(moment(schedule.start),'weeks') + 1
        event.endTime = moment(schedule.end).weeks(today.weeks())
        eventSouces[isoWeekday - 1].push event
    eventSouces

  genTimetable: (schedules, day)->
    if Auth.getCurrentUser().role is 'teacher'
      @genTeacherTimetable(schedules, day)
    else
      @genStudentTimetable(schedules, day)


.controller 'SchedulePopupCtrl', ($scope, $modalInstance, Restangular)->
  angular.extend $scope,
    close: ->
      $modalInstance.dismiss('close')

    loadCourses: ()->
      Restangular.all('courses').getList()
      .then (courses)->
        $scope.courses = courses

    courses: undefined

    viewState:
      course: undefined
      classe: undefined

    isBusy: ()->
      !$scope.courses

    resetClasse: ()->
      # reset
      $scope.viewState.classe = undefined

    create: ()->
      startMoment = moment($scope.viewState.startTime)
      endMoment = moment($scope.viewState.endTime)
      schedule =
        course: $scope.viewState.course._id
        classe: $scope.viewState.classe._id
        start: moment($scope.viewState.startDate).hours(startMoment.hours()).minute(startMoment.minute())._d
        end: moment($scope.viewState.startDate).hours(endMoment.hours()).minute(endMoment.minute())._d
        until: moment($scope.viewState.endDate)._d
      Restangular.all('schedules').post schedule
      .then (data)->
        $modalInstance.close data

    open: ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.viewState.fromPopOpened = true

    format: ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']

    dateOptions:
      formatYear: 'yy'
      startingDay: 1

    shifts: []

    weekdays:
      [
          title: '不重复'
          value: NaN
        ,
          title: '周一'
          value: '1'
        ,
          title: '周二'
          value: '2'
        ,
          title: '周三'
          value: '3'
        ,
          title: '周四'
          value: '4'
        ,
          title: '周五'
          value: '5'
        ,
          title: '周六'
          value: '6'
        ,
          title: '周日'
          value: '0'
      ]

    addShift: ()->
      $scope.shifts.push
        weekday: $scope.weekdays[0]
        start: moment()._d
        last: 90

    removeShift: (shift)->
      $scope.shifts.splice $scope.shifts.indexOf(shift), 1

  $scope.loadCourses()

