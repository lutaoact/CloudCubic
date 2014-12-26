'use strict'

angular.module('budweiserApp')

# 有 org 的时候会用到这个 controller
.controller 'OrgMainCtrl', (
  $q
  Auth
  $modal
  $scope
  Category
  Restangular
) ->

  generateCategories = ()->
    $q.all(_.uniq(_.pluck(_.pluck($scope.myCourses, 'categoryId').filter((x)-> x?),'_id')).map (id)->
      if id
        Category.find(id)
      else
        null
    )
    .then (categories)->
      categories = categories.filter (category)->
        category?
      $scope.myCategories = [{name:'全部'}].concat(categories)
      $scope.viewState.myCoursesFilters.category = $scope.myCategories[0]

  angular.extend $scope,
    Auth: Auth
    myCourses: null
    allCourses: null
    categories: null
    itemsPerPage: 6
    currentMyCoursesPage: 1
    maxSize: 3
    myInterval: 5000
    banners: [
      {
        image:'http://public-cloud3edu-com.qiniudn.com/cdn/images/banners/1/classroom.jpg'
        text: '学之方帮你打造云课堂'
      }
    ]
    viewState:
      myCoursesFilters:
        category: null

    createNewCourse: ->
      $modal.open
        templateUrl: 'app/teacher/teacherCourse/teacherNewCourse.html'
        controller: 'TeacherNewCourseCtrl'
        size: 'lg'
        resolve:
          categories: -> $scope.categories
      .result.then (newCourse) ->
        $scope.myCourses.push newCourse

    addSchedule: ($event)->
      $event.stopPropagation()

    loadMyCourses: ->

      if Auth.hasRole('teacher')
        Restangular
        .all('courses')
        .getList(owner: Auth.getCurrentUser()._id)
        .then (courses) ->
          $scope.myCourses = courses
          generateCategories()
      else
        Restangular
        .all('classes')
        .getList(studentId: Auth.getCurrentUser()._id)
        .then (classes) ->
          courseIds = _.map classes, (c) -> c.courseId._id
          Restangular
          .all('courses')
          .getList(ids: courseIds)
          .then (courses) ->
            $scope.myCourses = courses
            generateCategories()

  loadCategories = ->
    Category
    .find()
    .then (categories) ->
      $scope.categories = categories
      $scope.$categories = [{name:'全部'}].concat categories

  loadCategories()
