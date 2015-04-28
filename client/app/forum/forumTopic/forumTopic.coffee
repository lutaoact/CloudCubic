'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.topic',
    url: '/:forumId/topics/:topicId?replyId'
    templateUrl: 'app/forum/forumTopic/forumTopic.html'
    controller: 'ForumTopicCtrl'

