'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $scope
  $state
  notify
  configs
  $timeout
  $rootScope
  Restangular
  messageModal
) ->

  angular.extend $scope,

    imageSizeLimitation: configs.imageSizeLimitation

    viewState:
      editingInfo: false

    onThumbUploaded: (data)->
      $scope.course.thumbnail = data

    saveCourse: ()->
      Restangular.one('courses', $scope.course._id).patch
        categoryId: $scope.course.$category
        name: $scope.course.name
        thumbnail: $scope.course.thumbnail
      .then (newCourse)->
        angular.extend $scope.course, newCourse
        $scope.viewState.editing = false
        $scope.course.$category = _.find $scope.categories, (category)->
          category._id is $scope.course.categoryId._id
        notify
          message:'已保存'
          classes: 'alert-success'

    resetCourse: ()->
      Restangular.one('courses', $scope.course._id).get()
      .then (course)->
        angular.extend $scope.course, course
        $scope.viewState.editing = false

    removeCourse: ()->
      if $scope.classes.length != 0
        notify
          message:'删除失败，需要先删除该课程关联的班级'
          classes: 'alert-danger'
        return
      course = $scope.course
      messageModal.open
        title: -> '删除课程'
        message: -> "确认要删除《#{course.name}》？"
      .result.then ->
        course.remove().then ->
          $state.go('home')

    saveCourseInfo: ()->
      Restangular.one('courses', $scope.course._id).patch
        info: $scope.course.info
      .then (newCourse)->
        angular.extend $scope.course, newCourse
        $scope.viewState.editingInfo = false
        $scope.course.$category = _.find $scope.categories, (category)->
          category._id is $scope.course.categoryId._id
        notify
          message:'已保存'
          classes: 'alert-success'

    resetCourseInfo: ()->
      Restangular.one('courses', $scope.course._id).get()
      .then (course)->
        angular.extend $scope.course, course
        $scope.viewState.editingInfo = false


  Restangular.one('courses', $state.params.courseId).get()
  .then (course) ->
    $scope.course = course
    Restangular.all('categories').getList()
  .then (category) ->
    $scope.categories = categories
    $scope.course.$category = _.find $scope.categories, (category)->
      category._id is $scope.course.categoryId._id

    $scope.course.$teachers = $scope.course.owners
    Restangular.all('classes').getList({courseId: $scope.course._id})
  .then (classes)->
    $scope.classes = classes
    $scope.course.$teachers = _.uniq($scope.course.$teachers.concat(_.flatten(_.compact(_.pluck(classes, 'teachers')))),'_id')

  $scope.$on 'comments.number', (event, data)->
    $scope.course.commentsNum = data
