'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $scope
  $state
  Navbar
  $rootScope
  Category
  Restangular
  notify
  $modal
  configs
  $timeout
) ->

  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,

    deleteCallback: (course) ->
      Courses.splice(Courses.indexOf(course), 1)
      $state.go('main')

    imageSizeLimitation: configs.imageSizeLimitation

    togglePublish: ($event)->
      $event.stopPropagation()
      Restangular.one('courses', $scope.course._id).patch isPublished: !$scope.course.isPublished
      .then ->
        $scope.course.isPublished = !$scope.course.isPublished

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
      course = $scope.course
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除课程'
          message: -> "确认要删除《#{course.name}》？"
      .result.then ->
        course.remove().then ->
          $scope.deleteCallback?($course:course)

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
    Navbar.setTitle course.name, "teacher.course({courseId:'#{$state.params.courseId}'})"
    Category.find()
  .then (categories) ->
    $scope.categories = categories
    $scope.course.$category = _.find $scope.categories, (category)->
      category._id is $scope.course.categoryId._id

    $scope.course.$teachers = $scope.course.owners
    Restangular.all('classes').getList({courseId: $scope.course._id})
  .then (classes)->

    $scope.course.$teachers = _.uniq($scope.course.$teachers.concat(_.flatten(_.compact(_.pluck(classes, 'teachers')))),'_id')

  $scope.$on 'comments.number', (event, data)->
    $scope.course.commentsNum = data
