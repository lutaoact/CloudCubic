'use strict'

angular.module('budweiserApp').controller 'MainCtrl', (
  Page
  $scope
  $window
  $timeout
  Restangular
  $q
  org
) ->

  Page.setTitle '云立方学院 cloud3edu 提供教育云服务，教育的云计算时代，从云立方学院开始'

  angular.extend $scope,
    ios: '<div>ios</div>'
    org: org
  $scope.distance = 800

  Restangular.all('courses/public').getList()
  .then (result)->
    classeQs = result.map (course)->
      Restangular.all('classes').getList {courseId: course._id}
      .then (classes)->
        course.$classes = classes
        course
    $q.all(classeQs)
  .then (result)->
    console.log result
    $scope.courses = result

  resize = ()->
    $timeout ->
      $scope.distance = $window.innerHeight * 2 - 100

  resize()

  angular.element($window).bind 'resize', resize

  $scope.$on '$destroy', ->
    angular.element($window).unbind 'resize', resize



