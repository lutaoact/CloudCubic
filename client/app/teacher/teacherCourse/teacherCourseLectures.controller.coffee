'user strict'

angular.module('budweiserApp').directive 'teacherCourseLectures', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseLecturesCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseLectures.html'
  scope:
    course: '='
    classes: '='

angular.module('budweiserApp').controller 'TeacherCourseLecturesCtrl', (
  $scope
  $state
  $modal
  $rootScope
  Restangular
  messageModal
) ->

  angular.extend $scope,

    progressMap: {}
    activeProgressKey: null
    firstUndoLecture: null

    filter: (lecture, keyword) ->
      keyword = keyword ? ''
      name = lecture?.name ? ''
      content = lecture?.info ? ''
      text = _.str.clean(name + ' ' + content).toLowerCase()
      _.str.include(text, keyword)

    startTeaching: (course, lecture) ->
      classe = $scope.selectedClasse
      $state.go 'teacher.teaching',
        courseId: course._id
        classeId: classe._id
        lectureId: lecture._id

    selectClasse: (classe) ->
      if !classe
        return
      $scope.selectedClasse = classe
      $scope.activeProgressKey = classe._id
      if $scope.progressMap[$scope.activeProgressKey]?
        setFirstUndoLecture()
      else
        Restangular.all('progresses').getList({courseId: $scope.course._id, classeId: classe._id})
        .then (progress) ->
          $scope.progressMap[classe._id] = progress
          setFirstUndoLecture()

    createLecture: ->
      $scope.creating = true
      lecture =
        name: "新建课时 #{$scope.course.lectureAssembly.length + 1}"
        slides:[]
        keyPoints: []
        homeworks:[]
        quizzes:[]
      Restangular.all('lectures').post(lecture, courseId:$scope.course._id)
      .then (newLecture) ->
        $scope.creating = false
        $state.go('teacher.lecture', courseId: $scope.course._id, lectureId: newLecture._id)

    deleteLecture: (lecture) ->
      messageModal.open
        title: -> '删除课时'
        message: -> """确认要删除《#{$scope.course.name}》中的"#{lecture.name}"？"""
      .result.then ->
        lecture.remove(courseId:$scope.course._id)
        .then ->
          lectures = $scope.course.$lectures
          lectures.splice(lectures.indexOf(lecture), 1)
          setFirstUndoLecture()

    sortLecture: ->
      $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

    addClass: ()->
      $modal.open
        templateUrl: 'app/admin/classeManager/editClasseModal.html'
        controller: 'EditClasseModalCtrl'
        windowClass: 'edit-classe-modal'
        resolve:
          Courses: -> null
          Teachers: -> Restangular.all('users').getList(role:'teacher')
          Classe: ->
            name: ''
            price: 0
            enrollment: {}
            duration: {}
            courseId: $scope.course._id
      .result.then (newClasse) ->
        $scope.classes.splice 0, 0, newClasse

    classDeleteCallback: (classe)->
      deleteClasseIndex = $scope.classes.indexOf(classe)
      $scope.classes.splice deleteClasseIndex, 1
      $scope.selectedClasse = null
      $scope.selectClasse($scope.classes?[0])

  reloadLectures = (course) ->
    if !course._id? then return
    # load course
    Restangular.all('lectures').getList(courseId:course._id)
    .then (lectures) ->
      course.$lectures = course.lectureAssembly

  setFirstUndoLecture = ->
    progress = $scope.progressMap[$scope.activeProgressKey]
    $scope.firstUndoLecture = _.find($scope.course.$lectures, (l) -> progress.indexOf(l._id) == -1)

  $scope.$watch 'course', (value) ->
    if value
      reloadLectures($scope.course)

  $scope.$watch 'classes', (value) ->
    if value
      $scope.selectClasse(value[0])
