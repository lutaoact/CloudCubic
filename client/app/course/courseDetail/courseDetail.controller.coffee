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

  if !$state.params.classeId
    Restangular.all('classes').getList(courseId: $state.params.courseId)
    .then (classes)->
      if classes?.length
        $state.go 'courseDetail', {courseId: $state.params.courseId,classeId: classes[0]._id}
      else
        $state.go 'home'
        notify
          message:'该班级不存在'
          classes: 'alert-warning'
    return

  angular.extend $scope,
    Auth: Auth
    itemsPerPage: 10
    currentPage: 1
    course: null
    courseTab:
      type: 'desc'

    loadProgress: ->
      $scope.viewedLectureIndex = 1
      if !$state.params.courseId or !Auth.isLoggedIn() then return
      Restangular.all('progresses').getList({courseId: $state.params.courseId})
      .then (progress)->
        progress?.forEach (lectureId)->
          viewedLecture = _.find $scope.course.$lectures, _id: lectureId
          viewedLecture?.$viewed = true
          $scope.viewedLectureIndex = $scope.course.$lectures.indexOf(viewedLecture) + 1 if $scope.viewedLectureIndex < $scope.course.$lectures.indexOf(viewedLecture) + 1

    gotoLecture: ()->
      if !$scope.course.$lectures?.length
        return
      viewedLectures = $scope.course.$lectures.filter (x)->
        x.$viewed
      if viewedLectures and viewedLectures.length > 0
        # GOTO that course
        # TODO: last viewed should not be the last viewed item :(
        lastViewed = viewedLectures[viewedLectures.length - 1]
        $state.go 'lectureDetail',
          courseId: $state.params.courseId
          lectureId: lastViewed._id

      else
        # Start from first lecture
        $state.go 'lectureDetail',
          courseId: $state.params.courseId
          lectureId: $scope.course.$lectures[0]._id

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

  # 获取该课程的基本信息
  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    course.$lectures = course.lectureAssembly
    $scope.course = course
    $scope.loadProgress()

  # 获取班级信息
  Restangular.one('classes',$state.params.classeId).get()
  .then (classe)->
    $scope.classe = classe
  , (err)->
    console.log err
