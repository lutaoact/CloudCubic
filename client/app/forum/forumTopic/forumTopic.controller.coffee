'use strict'

angular.module('budweiserApp').controller 'ForumTopicCtrl',
(
  $q
  $scope
  $state
  Navbar
  CurrentUser
  Restangular
) ->

  if not $state.params.forumId or not $state.params.topicId
    return

  if $state.params.topicId and $state.params.forumId is 'unknow'
    Restangular.one('topics', $state.params.topicId).get()
      .then (topic)->
        $state.go 'forum.topic',
          forumId: topic.forumId
          topicId: $state.params.topicId
    return

  $scope.$on '$destroy', Navbar.resetTitle

  angular.extend $scope,
    loading: true
    topic: null
    me: CurrentUser
    stateParams: $state.params

    loadTopic: (replyId)->
      Restangular.one('topics', $state.params.topicId).get()
      .then (topic)->
        $scope.topic = topic
        # $state.params.replyId will not change on reloading if reloadOnSearch is set false and only the query param changed.
        # In this case, get replyId from navbar controller using broadcast ..
        $scope.topic.$currentReplyId = if replyId then replyId else $state.params.replyId

    recommendedTopics: undefined

    loadRecommendedTopics: ()->
      Restangular.all('topics').getList(forumId: $state.params.forumId)
      .then (topics)->
        $scope.recommendedTopics = topics.slice 0,3

  $q.all [
    $scope.loadTopic()
    $scope.loadRecommendedTopics()
  ]
  .then ()->
    $scope.loading = false

  Restangular.one('forums',$state.params.forumId).get()
  .then (forum)->
    $scope.forum = forum

  $scope.$on 'forum/reloadReplyList', (event, replyId)->
    $scope.loadTopic(replyId)
    #   $scope.topic.$currentReplyId = replyId
    # if replyId
