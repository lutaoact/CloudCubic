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
        if lecture.isFreeTry then return done()
        # 如果没有登录
        if !Auth.isLoggedIn()
          $modal.open
            templateUrl: 'app/login/loginModal.html'
            controller: 'loginModalCtrl'
            windowClass: 'login-window-modal'
            size: 'md'
          .result.then checkPermission
          return
        # 如果登录用户不是学生
        if Auth.hasRole('teacher')
          $modal.open
            templateUrl: 'components/modal/messageModal.html'
            windowClass: 'message-modal'
            controller: 'MessageModalCtrl'
            size: 'sm'
            resolve:
              title: -> '无权查看收费课时'
              message: -> "请先登录学生账户查看收费课时"
          return
        # 如果登录用户没有购买
        if $scope.classe.students.indexOf(Auth.getCurrentUser()._id) is -1
          $modal.open
            templateUrl: 'components/modal/messageModal.html'
            windowClass: 'message-modal'
            controller: 'MessageModalCtrl'
            size: 'sm'
            resolve:
              title: -> '无权查看收费课时'
              message: -> "请先购买或参加该课程"
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
