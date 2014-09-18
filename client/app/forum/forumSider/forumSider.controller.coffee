'use strict'

angular.module('budweiserApp').controller 'ForumSiderCtrl',
(
  $scope
  Restangular
  notify
  $state
  $q
  $rootScope
  $sce
  $document
  $window
  $timeout
  $modal
  Auth
) ->

  $rootScope.additionalMenu = [
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "student.courseDetail({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "teacher.courseDetail({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
    {
      title: '讨论<i class="fa fa-comments-o"></i>'
      link: "forum.course({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "student.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "teacher.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
  ]

  $scope.$on '$destroy', ()->
    $rootScope.additionalMenu = []

  if not $state.params.courseId
    return
  angular.extend $scope,
    loading: true

    course: null

    topics: null

    myTopic: null

    posting: false

    me: Auth.getCurrentUser()

    currentTopic: undefined

    imagesToInsert: undefined

    loadCourse: ()->
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        Restangular.all('key_points').getList(categoryId: course.categoryId)
        .then (keypoints)->
          $scope.keypoints = keypoints
        $scope.course = course

    loadLectures: ()->
      Restangular.all('lectures').getList({courseId: $state.params.courseId})
      .then (lectures)->
        $scope.course.$lectures = lectures


    loadTopics: ()->
      Restangular.all('dis_topics').getList({courseId: $state.params.courseId})
      .then (topics)->
        # pull out the tags in content
        topics.forEach (topic)->
          topic.$tags = (topic.content.match /<div\s+class="tag\W.*?<\/div>/)?.join()
        $scope.topics = topics

    createTopic: ()->
      # validate
      $modal.open
        templateUrl: 'app/forum/discussionComposerPopup/discussionComposerPopup.html'
        controller: 'DiscussionComposerPopupCtrl'
        resolve:
          keypoints: -> $scope.keypoints
          course: -> $scope.course
          lectures: -> $scope.course.$lectures
          topics: -> $scope.topics
      .result.then (dis_topic)->
        $scope.topics.splice 0, 0, dis_topic

    viewTopic: (topic)->
      $scope.currentTopic = undefined
      $scope.showTopic = true
      Restangular.one('dis_topics', topic._id).get()
      .then (topic)->
        topic.$unsafeContent = $sce.trustAsHtml topic.content
        $scope.currentTopic = topic
        Restangular.all('dis_replies').getList({disTopicId: topic._id})
      .then (replies)->
        replies.forEach (reply)->
          reply.$unsafeContent = $sce.trustAsHtml reply.content
        $scope.currentTopic.$replies = replies

    backToList: ()->
      $scope.currentTopic = undefined
      $scope.showTopic = false

    clientHeight: undefined

    onImgUploaded: (key)->
      @imagesToInsert ?= []
      @imagesToInsert.push
        url: "/api/assets/images/#{key}-blog"
        key: key

    newReply: {}
    replying: false

    replyTo: (topic, reply)->
      # validate
      @replying = true
      @imagesToInsert?.forEach (image)->
        reply.content += "<img class=\"sm image-zoom\" src=\"#{image.url}\">"
      topic.$replies.post reply, {disTopicId: topic._id}
      .then (dis_reply)->
        dis_reply.$unsafeContent = $sce.trustAsHtml dis_reply.content
        topic.$replies.splice 0, 0, dis_reply
        $scope.initMyReply()
        $scope.replying = false
        $scope.imagesToInsert = undefined

    initMyReply: ()->
      @newReply = {} if !@newReply
      @newReply.content = ''

    toggleVote: (reply)->
      reply.one('vote').post()
      .then (res)->
        reply.voteUpUsers = res.voteUpUsers

  setclientHeight = ()->
    $scope.clientHeight =
      "min-height": $window.innerHeight

  setclientHeight()

  handle = angular.element($window).bind 'resize', setclientHeight

  $scope.$on '$destroy', ->
    angular.element($window).unbind 'resize', setclientHeight

  $q.all [
    $scope.loadCourse().then $scope.loadLectures
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false


