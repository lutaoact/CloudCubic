'use strict'

angular.module('budweiserApp')

.factory 'Permission', ->

  checkViewLecture: (user, lecture, classe, course) ->
    isFreeTry = lecture.isFreeTry
    isAdmin   = user?.role is 'admin'
    isOwner   = _.find(course?.owners, _id:user?._id)
    isTeacher = _.find(classe?.teachers, _id: user?._id)
    isLearner = classe?.students?.indexOf(user?._id) != -1
    if isFreeTry or isAdmin or isOwner or isTeacher or isLearner
      return 'allow'

    switch user?.role
      when 'teacher'
        # 登录的老师不是course的owner或者不是classe的teacher
        return 'ownerRequired'
      when 'student'
        # 登录的学生没有购买或者参加
        return if classe.price is 0 then 'enrollRequired' else 'buyRequired'
      else
        return 'loginRequired'

.controller 'CourseDetailCtrl', (
  $q
  Auth
  $scope
  $state
  notify
  $modal
  Category
  $rootScope
  Permission
  Restangular
  messageModal
) ->

  angular.extend $scope,
    Auth: Auth
    itemsPerPage: 10
    currentPage: 1
    courseTab:
      type: $state.$current.name.split('.').pop()

    learnLecture: ->
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
      .then (data)->
        console.log 'enrolled!'
        $scope.classe.students = data[0].students

  $scope.$watch 'course', (course) ->
    if course && !course.info
      $scope.courseTab.type = 'lecture'

  $scope.$on 'comments.number', (event, data)->
    $scope.course.commentsNum = data

  $scope.$on '$stateChangeStart', (event, toState, toParams)->
    if toState.name is "course.lecture"
      lecture = _.find $scope.course.lectureAssembly, {'_id': toParams.lectureId}
      permission = Permission.checkViewLecture(Auth.getCurrentUser(), lecture, $scope.classe, $scope.coruse)
      if permission isnt 'allow'
        event.preventDefault()
        switch permission
          when 'ownerRequired'
            messageModal.open
              title: -> "无权查看此课时"
              message: -> """您不能查看其他教师的课程"""
              buttons: -> [
                label: '关闭', code: 'cancel', class: 'btn-default'
              ]
          when 'enrollRequired'
            messageModal.open
              title: -> "请先参加课程"
              message: -> """您还不能查看此课时，请先参加此课程 “#{$scope.classe.name}”"""
              buttons: -> [
                label: '取消'      , code: 'cancel'    , class: 'btn-default'
              ,
                label: '参加课程'  , code: 'enroll'    , class: 'btn-primary'
              ]
            .result.then (actionCode) ->
              if actionCode is 'enroll'
                $scope.enrollFreeClass($scope.classe)
          when 'buyRequired'
            messageModal.open
              title: -> "请先购买课程"
              message: -> """您还不能查看此课时，请先购买此课程 “#{$scope.classe.name}”"""
              buttons: -> [
                label: '取消'      , code: 'cancel'    , class: 'btn-default'
              ,
                label: '直接购买'  , code: 'buyNow'    , class: 'btn-primary'
              ,
                label: '加入购物车', code: 'addToCart' , class: 'btn-primary'
              ]
            .result.then (actionCode) ->
              switch actionCode
                when 'buyNow'
                  $scope.makeOrder($scope.classe)
                when 'addToCart'
                  $scope.addToCart($scope.classe)
          when 'loginRequired'
            $modal.open
              templateUrl: 'app/login/loginModal.html'
              controller: 'loginModalCtrl'
              windowClass: 'login-window-modal'
            .result.then ->
              $state.go(toState, toParams)

  $scope.$watch "courseTab.type", (newType)->
    $state.go "course.detail."+newType