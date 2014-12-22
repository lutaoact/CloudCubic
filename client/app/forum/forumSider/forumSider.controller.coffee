'use strict'

angular.module('budweiserApp').controller 'ForumSiderCtrl',
(
  $scope
  Restangular
  $state
  $q
  $rootScope
  $window
  $timeout
  $modal
  Auth
  $filter
) ->

  if not $state.params.courseId
    return
  angular.extend $scope,
    loading: true

    topics: null

    currentTopic: undefined

    lectureId: $state.params.lectureId

    loadTopics: ()->
      Restangular.all('dis_topics').getList({courseId: $state.params.courseId})
      .then (topics)->
        # pull out the tags in content
        topics.forEach (topic)->
          topic.$heat = 1000 / (moment().diff(moment(topic.created),'hours') + 1)+ topic.commentsNum * 10 + topic.voteUpUsers.length * 10
        $scope.topics = $filter('filter')(topics, $state.params.lectureId)

    viewTopic: (topic)->
      $scope.currentTopic = undefined
      $scope.showTopic = true
      Restangular.one('dis_topics', topic._id).get()
      .then (topic)->
        $scope.currentTopic = topic
        Restangular.all('comments').getList({belongTo: topic._id, type: Const.CommentType?.DisTopic})
      .then (replies)->
        replies.forEach (reply)->
        $scope.currentTopic.$comments = replies

    backToList: ()->
      $scope.currentTopic = undefined
      $scope.showTopic = false

  $q.all [
    $scope.loadTopics()
  ]
  .then ()->
    $scope.loading = false


