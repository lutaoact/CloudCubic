'user strict'

angular.module('budweiserApp').directive 'teacherCourseLectures', ->
  restrict: 'EA'
  replace: true
  controller: 'TeacherCourseLecturesCtrl'
  templateUrl: 'app/teacher/teacherCourse/teacherCourseLectures.html'
  scope:
    course: '='

angular.module('budweiserApp').controller 'TeacherCourseLecturesCtrl', (
  $scope
  $state
  $modal
  $rootScope
  Restangular
  messageModal
) ->

  angular.extend $scope,

    filter: (lecture, keyword) ->
      keyword = keyword ? ''
      name = lecture?.name ? ''
      content = lecture?.info ? ''
      text = _.str.clean(name + ' ' + content).toLowerCase()
      _.str.include(text, keyword)

    createLecture: ->
      $scope.creating = true
      lecture =
        name: "新建课时 #{$scope.course.lectureAssembly.length + 1}"
        slides:[]
        keyPoints: []
        homeworks:[]
        quizzes:[]
      Restangular
      .all('lectures')
      .post(lecture, courseId:$scope.course._id)
      .then (newLecture) ->
        $scope.creating = false
        $state.go('teacher.lecture', courseId: $scope.course._id, lectureId: newLecture._id)

    deleteLecture: (lecture) ->
      messageModal.open
        title: -> '删除课时'
        message: -> """确认要删除《#{$scope.course.name}》中的"#{lecture.name}"？"""
      .result.then ->
        Restangular
        .one('lectures', lecture._id)
        .remove(courseId:$scope.course._id)
        .then ->
          lectures = $scope.course.lectureAssembly
          lectures.splice(lectures.indexOf(lecture), 1)

    sortLecture: ->
      $scope.course.patch lectureAssembly:_.pluck($scope.course.lectureAssembly, '_id')
