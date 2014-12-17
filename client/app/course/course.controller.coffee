'use strict'

angular.module('budweiserApp').controller 'CourseCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
  $location
) ->
  Restangular.all('courses').customGET("#{$state.params.courseId}/public")
  .then (course)->
    $scope.course = course
    Navbar.setTitle $scope.course.name, "course({courseId:'#{$state.params.courseId}'})"
    $scope.$on '$destroy', Navbar.resetTitle

  Restangular.all('classes').getList(courseId: $state.params.courseId)
  .then (classes)->
    $scope.classes = classes

  angular.extend $scope,
    itemsPerPage: 10
    currentPage: 1

    enroll: (classe)->
      qs =
        classId: classe._id
        subject: classe.name
        total_fee: classe.price
        body: classe.name
        show_url: $location.absUrl()

      Restangular.one('payments', 'create_direct_pay_by_user').get(qs)
      .then (data)->
        url = "https://mapi.alipay.com/gateway.do?" + $.param(data.plain())
        window.open url, "MsgWindow", "top=50, left=50, width=800, height=600"