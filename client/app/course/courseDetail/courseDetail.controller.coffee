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
        # 如果是试用课时或者免费班级或者管理员可以直接看课时
        if lecture.isFreeTry or
           $scope.classe.price is 0 or
           Auth.hasRole('admin')
          return done()
        # 如果没有登录
        if !Auth.isLoggedIn()
          $modal.open
            templateUrl: 'app/login/loginModal.html'
            controller: 'loginModalCtrl'
            windowClass: 'login-window-modal'
            size: 'md'
          .result.then -> checkPermission(done)
          return
        # 如果登录的用户不是course的owner或者不是classe的teacher
        # 如果登录用户没有购买或者参加
        currentUser = Auth.getCurrentUser()._id
        isOwnerOrTeacher = _.find(_.union($scope.classe.teachers, $scope.course.owners), _id:currentUser)
        isUserInClasse   = $scope.classe.students.indexOf(currentUser) >= 0
        if !isOwnerOrTeacher and !isUserInClasse
          messageModal.open
            title: -> "无权查看此课时"
            message: -> """您还不能查看此收费课时，请先购买课程 “#{$scope.classe.name}”"""
            # 消息按钮可选，默认是：取消 确认
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
          return
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
