'use scrict'

angular.module('budweiserApp')

.controller 'EditClasseModalCtrl', (
  $scope
  Classe
  notify
  Courses
  Teachers
  Restangular
  $modalInstance
) ->

  console.log Teachers

  angular.extend $scope,
    errors: null
    classe: Classe
    courses: Courses
    teachers: Teachers

    addTeacher: (teacher) ->
      console.log 'addTeacher', teacher
      if !teacher? then return
      $scope.classe.teachers = _.union($scope.classe.teachers, [teacher])

    removeTeacher: (teacher) ->
      index = $scope.classe.teachers.indexOf(teacher)
      $scope.classe.teachers.splice(index, 1)

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      $scope.errors = null
      $scope.classe.schedules = $scope.getSchedules()
      $scope.classe.teachers = _.map $scope.classe.teachers, (t) -> t._id
      (
        if $scope.classe._id?
          Restangular.one('classes', $scope.classe._id).patch($scope.classe)
        else
          Restangular.all('classes').post($scope.classe)
      )
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors
        notify
          message: '编辑开课班级信息失败'
          classes: 'alert-danger'

    isNaN: (value)->
      isNaN(value)

    getSchedules: ()->
      if $scope.shifts.length
        schedules = []
        $scope.shifts.forEach (shift)->
          startMoment = null
          endMoment = null
          untilMoment = null
          if isNaN(shift.weekday.value)
            startMoment = moment(shift.date).hours(shift.start.hour).minute(shift.start.minute)._d
            endMoment = moment(shift.date).hours(shift.start.hour).minute(shift.start.minute).add(shift.last,'minutes')._d
            untilMoment = endMoment
          else
            startMoment = moment($scope.viewState.startDate).isoWeekday(shift.weekday.value).hours(shift.start.hour).minute(shift.start.minute)._d
            endMoment = moment($scope.viewState.startDate).isoWeekday(shift.weekday.value).hours(shift.start.hour).minute(shift.start.minute).add(shift.last,'minutes')._d
            untilMoment = moment($scope.viewState.endDate).isoWeekday(shift.weekday.value)._d

          schedule =
            course: $scope.classe.courseId._id
            classe: $scope.classe._id
            start: startMoment
            end: endMoment
            until: untilMoment

          schedules.push schedule
        schedules
      else
        []

    getShifts: ()->
      $scope.shifts = []
      if $scope.classe
        $scope.viewState.startDate = $scope.classe.duration.from
        $scope.viewState.endDate = $scope.classe.duration.to
        console.log $scope.classe
        $scope.shifts = $scope.classe.schedules?.map (schedule)->
          weekday: if moment(schedule.end).isSame(moment(schedule.until),'day') then $scope.weekdays[0] else $scope.weekdays[moment(schedule.start).isoWeekday()]
          date: moment(schedule.start)._d
          start:
            hour: moment(schedule.start).get('hour')
            minute: moment(schedule.start).get('minute')
          last: (moment(schedule.end).get('hour') * 60 + moment(schedule.end).get('minute')) - (moment(schedule.start).get('hour') * 60 + moment(schedule.start).get('minute'))
      else
        $scope.shifts = []

    shifts: []

    # sequence matters!
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
          value: '7'
      ]

    durations: [0..60].map (index)-> (index * 5 + 30)
    hours: [0..23]
    minutes: [0..11].map (index)-> (index * 5)
    addShift: ()->
      $scope.shifts ?= []
      $scope.shifts.push
        weekday: $scope.weekdays[0]
        start:
          hour: 9
          minute: 0
        last: 90
        date: moment($scope.viewState.startDate)._d

    removeShift: (shift)->
      $scope.shifts.splice $scope.shifts.indexOf(shift), 1


    viewState:
      dateOptions:
        startingDay: 0
        "show-weeks": false

  $scope.getShifts()
