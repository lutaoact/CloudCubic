'use strict'

angular.module('budweiserApp')

.factory 'Permission', ->

  checkViewLecture: (user, lecture, classe, course) ->
    forFree   = lecture.isFreeTry or classe.price is 0
    isAdmin   = user?.role is 'admin'
    isOwner   = _.find(course?.owners, _id:user?._id)
    isTeacher = _.find(classe?.teachers, _id: user?._id)
    isLearner = classe?.students?.indexOf(user?._id) != -1
    if forFree or isAdmin or isOwner or isTeacher or isLearner
      return 'allow'

    switch user?.role
      when 'teacher' # 登录的老师不是course的owner或者不是classe的teacher
        return 'ownerRequired'
      when 'student' # 登录的学生没有购买
        return 'buyRequired'
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
    progress: null

    loadProgress: ->
      $scope.progress = null

      if !Auth.isLoggedIn() then return
      me = $scope.me
      isAdmin   = me?.role is 'admin'
      isOwner   = _.find($scope.course?.owners, _id:me?._id)
      isTeacher = _.find($scope.classe?.teachers, _id: me?._id)
      isLearner = $scope.classe?.students?.indexOf(me?._id) != -1

      if isAdmin or isOwner or isTeacher or isLearner
        Restangular
        .all('progresses')
        .getList(
          courseId: $state.params.courseId
          classeId: $state.params.classeId
        )
        .then (progress) ->
          # 移除不是这个课程的progress
          $scope.progress = _.intersection(progress, _.pluck($scope.course.lectureAssembly, '_id'))

    gotoLecture: ->
      lectures = $scope.course.lectureAssembly
      # 找到第一个需要学习的课时 / 找到第一个没有在progress里面的课时
      lectureToLearn = _.find lectures, (lecture) ->
        $scope.progress.indexOf(lecture._id) == -1
      # 如果lecture都已经学习完，定位到最后一个
      lectureToLearn = lectures[lectures.length - 1] if !lectureToLearn?
      if lectureToLearn?
        # 如果是老师，跳到上课界面；如果是学生，跳到课时详情
        stateName = if Auth.hasRole('teacher') then 'teacher.teaching' else 'course.lecture'
        $state.go stateName,
          courseId: $state.params.courseId
          classeId: $state.params.classeId
          lectureId: lectureToLearn._id

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
        $scope.classe.students = data[0].students
        $scope.loadProgress()

  $scope.$watch Auth.getCurrentUser, (me) ->
    $q.all [
      $scope.classeQ
      $scope.courseQ
    ]
    .then $scope.loadProgress

  $scope.$on 'comments.number', (event, data)->
    $scope.course.commentsNum = data

  if $state.current.name is 'course.detail'
    $state.go 'course.detail.desc'

  $scope.$on '$stateChangeStart', (event, toState, toParams)->
    if toState.name is 'course.detail'
      event.preventDefault()
      $state.go 'course.detail.desc'
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

