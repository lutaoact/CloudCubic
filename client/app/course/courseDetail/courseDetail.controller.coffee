'use strict'

angular.module('budweiserApp').controller 'CourseDetailCtrl', (
  $q
  Auth
  $scope
  $state
  Category
  $rootScope
  Restangular
  notify
) ->

  angular.extend $scope,
    Auth: Auth
    itemsPerPage: 10
    currentPage: 1
    courseTab:
      type: 'desc'

    gotoLecture: ()->
      if !$scope.course.lectureAssembly?.length
        return
      viewedLectures = $scope.course.lectureAssembly.filter (x)->
        x.$viewed
      if viewedLectures and viewedLectures.length > 0
        # GOTO that course
        # TODO: last viewed should not be the last viewed item :(
        lastViewed = viewedLectures[viewedLectures.length - 1]
        $state.go 'lecture.detail',
          courseId: $state.params.courseId
          lectureId: lastViewed._id

      else
        # Start from first lecture
        $state.go 'course.lecture',
          lectureId: $scope.course.lectureAssembly[0]._id

    addToCart: (classe)->
      if Auth.hasRole('teacher')
        notify
          message: '请登录学生账户购买该课程开班'
          classes: 'alert-danger'
        return
      Restangular.all('carts/add').post classes: [classe._id]
      .then (result)->
        $rootScope.$broadcast 'addedToCart', result

    makeOrder: (classe)->
      if Auth.hasRole('teacher')
        notify
          message: '请登录学生账户购买该课程开班'
          classes: 'alert-danger'
        return
      Restangular.all('orders').post classes: [classe._id]
      .then (order)->
        $state.go 'order', orderId: order._id

    enrollFreeClass: (classe)->
      if Auth.hasRole('teacher')
        notify
          message: '请登录学生账户参加该课程开班'
          classes: 'alert-danger'
        return
      Restangular.all('classes').one(classe._id, 'enroll').post()
      .then ->
        console.log 'enrolled!'
        #TODO: redirect to course page

    weekdays: ['周一','周二','周三','周四','周五','周六','周日']

    genScheduleSummary: (schedules)->
      if schedules?.length
        summary = ''
        schedules.forEach (schedule)->
          summary += if moment(schedule.end).isSame(moment(schedule.until),'day') then moment(schedule.start).format('M月D日') else "每#{$scope.weekdays[moment(schedule.start).isoWeekday()-1]}"
          summary += moment(schedule.start).format('HH:mm')
          summary += '-'
          summary += moment(schedule.end).format('HH:mm')
          summary += ', '
        summary = summary.substr(0,summary.length-2) + '。'
        summary
      else
        '无具体上课时间'

    # only show buy class for student
    showBuyClass : ->
      ($scope.classe.price > 0) && (Auth.userRole() is 'student')

    # only show join class for student
    showJoinClass : ->
      ($scope.classe.price is 0) && (Auth.userRole() is 'student')
      
      
  $scope.$on 'comments.number', (event, data)->
    $scope.course.commentsNum = data
