'use scrict'

angular.module('budweiserApp')

.controller 'EditClasseModalCtrl', (
  $scope
  Classe
  notify
  Courses
  Teachers
  Restangular
  $modalInstance
) ->

  console.log Teachers

  angular.extend $scope,
    errors: null
    classe: Classe
    courses: Courses
    teachers: Teachers

    addTeacher: (teacher) ->
      console.log 'addTeacher', teacher
      if !teacher? then return
      $scope.classe.teachers = _.union($scope.classe.teachers, [teacher])

    removeTeacher: (teacher) ->
      index = $scope.classe.teachers.indexOf(teacher)
      $scope.classe.teachers.splice(index, 1)

    cancel: ->
      $modalInstance.dismiss('cancel')

    confirm: (form) ->
      if !form.$valid then return
      $scope.errors = null
      $scope.classe.teachers = _.map $scope.classe.teachers, (t) -> t._id
      (
        if $scope.classe._id?
          Restangular.one('classes', $scope.classe._id).patch($scope.classe)
        else
          Restangular.all('classes').post($scope.classe)
      )
      .then $modalInstance.close
      .catch (error) ->
        $scope.errors = error?.data?.errors
        notify
          message: '编辑开课班级信息失败'
          classes: 'alert-danger'

    viewState:
      dateOptions:
        startingDay: 0
        "show-weeks": false
