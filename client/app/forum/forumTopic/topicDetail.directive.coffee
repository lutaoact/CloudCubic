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

.controller 'TopicDetailCtrl', ($scope, Auth, Restangular, $timeout, $document, $state, $modal)->
  angular.extend $scope,

    me: Auth.getCurrentUser

    toggleLike: (topic)->
      topic.one('vote').post()
      .then (res)->
        topic.likeUsers = res.likeUsers

  $scope.$on 'message.notice', (event, raw)->
    switch raw.type
      when Const.NoticeType.TopicVoteUp
        if raw.data.disTopic._id is $scope.topic._id
          $scope.topic.likeUsers = raw.data.disTopic.likeUsers
      when Const.NoticeType.ReplyVoteUp
        myReplie = $scope.topic.$comments.filter (item)->
          item._id is raw.data.disReply._id
        if myReplie?.length
          myReplie[0].likeUsers = raw.data.disReply.likeUsers

  $scope.$watch 'activeReply', (value)->
    $scope.dataId = value


