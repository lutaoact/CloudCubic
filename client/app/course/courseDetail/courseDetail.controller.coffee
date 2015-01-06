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
      console.log classes
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
      type: 'lecture'

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
      Restangular.all('carts/add').post classes: [classe._id]
      .then (result)->
        $rootScope.$broadcast 'addedToCart', result

    makeOrder: (classe)->
      Restangular.all('orders').post classes: [classe._id]
      .then (order)->
        $state.go 'order', orderId: order._id

    enrollFreeClass: (classe)->
      Restangular.all('classes').one(classe._id, 'enroll').post()
      .then ->
        console.log 'enrolled!'
        #TODO: redirect to course page

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

