'use strict'

angular.module('budweiserApp')

.directive 'topicDetail', ->
  restrict: 'E'
  replace: true
  controller: 'TopicDetailCtrl'
  templateUrl: 'app/forum/forumTopic/topicDetail.template.html'
  scope:
    topic: '='
    activeReply: '@'

.controller 'TopicDetailCtrl',
(
  $scope
  Auth
  Restangular
  $timeout
  $document
  $state
  $modal
  messageModal
)->
  angular.extend $scope,

    me: Auth.getCurrentUser

    toggleLike: (topic)->
      topic.one('like').post()
      .then (res)->
        topic.likeUsers = res.likeUsers

    editTopic: (topic)->
      $modal.open
        templateUrl: 'app/forum/discussionComposerPopup/discussionComposerPopup.html'
        controller: 'DiscussionComposerPopupCtrl'
        windowClass: 'bud-modal'
        backdrop: 'static'
        keyboard: false
        resolve:
          topic: -> angular.copy(topic)
      .result.then (newTopic)->
        angular.extend topic, newTopic

    deleteTopic: (topic)->
      messageModal.open
        title: -> '删除帖子'
        message: -> "是否要删除您的帖子：\"#{topic.title}\"，删除后将无法恢复！"
      .result.then ->
        topic.remove()
      .then ()->
        $state.go 'forum.detail', forumId: $state.params.forumId

  $scope.$watch 'activeReply', (value)->
    $scope.dataId = value


