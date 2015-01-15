'use strict'

angular.module('budweiserApp').controller 'CourseDetailCtrl', (
  $q
  Auth
  $scope
  $state
  notify
  $modal
  Category
  $rootScope
  Restangular
  messageModal
) ->

  angular.extend $scope,
    Auth: Auth
    itemsPerPage: 10
    currentPage: 1
    courseTab:
      type: 'desc'

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

    viewLecture: (lecture) ->
      checkPermission = (done) ->
        return done() if lecture.isFreeTry # 如果是试用课时可以直接看课时
        currentUser = Auth.getCurrentUser()._id
        switch Auth.getCurrentUser()?.role
          when 'admin'
            # 如果是管理员，直接进入课时
            done()
          when 'teacher'
            # 如果登录的用户不是course的owner或者不是classe的teacher
            isOwnerOrTeacher = _.find(_.union($scope.classe.teachers, $scope.course.owners), _id:currentUser)
            if !isOwnerOrTeacher
              return messageModal.open
                title: -> "无权查看此课时"
                message: -> """您不能查看其他教师的课程"""
                buttons: -> [
                  label: '关闭', code: 'cancel', class: 'btn-default'
                ]
          when 'student'
            # 如果登录的学生没有购买或者参加
            isStudentInClasse = $scope.classe.students.indexOf(currentUser) >= 0
            if !isStudentInClasse
              isFreeClasse = $scope.classe.price is 0
              return messageModal.open
                title: ->
                  if isFreeClasse then "请先参加课程" else "请先购买课程"
                message: ->
                  if isFreeClasse
                    """您还不能查看此课时，请先参加此课程 “#{$scope.classe.name}”"""
                  else
                    """您还不能查看此课时，请先购买此课程 “#{$scope.classe.name}”"""
                # 消息按钮可选，默认是：取消 确认
                buttons: ->
                  if isFreeClasse
                    [
                      label: '取消'      , code: 'cancel'    , class: 'btn-default'
                    ,
                      label: '参加课程'  , code: 'enroll'    , class: 'btn-primary'
                    ]
                  else
                    [
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
                  when 'enroll'
                    $scope.enrollFreeClass($scope.classe)
          else
            # 未登录用户不能查看课时
            return $modal.open
              templateUrl: 'app/login/loginModal.html'
              controller: 'loginModalCtrl'
              windowClass: 'login-window-modal'
              size: 'md'
            .result.then -> checkPermission(done)
        done()

      checkPermission ->
        $state.go 'course.lecture',
          courseId:$scope.course._id
          lectureId:lecture._id

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

  $scope.courseTab.type = 'lecture' if !$scope.course?.desc

  $scope.$on 'comments.number', (event, data)->
    $scope.course.commentsNum = data
