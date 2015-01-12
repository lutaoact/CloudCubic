'use strict'

angular.module('budweiserApp')

.directive 'topicList', ->
  restrict: 'E'
  replace: true
  controller: 'TopicListCtrl'
  templateUrl: 'app/forum/forumDetail/topicList.template.html'
  scope:
    topics: '='
    onTopicClick: '&'
    onTagClick: '&'

.controller 'TopicListCtrl', ($scope, Auth, $modal, Restangular, $state)->
  angular.extend $scope,
    selectTopic: (topic)->
      $scope.selectedTopic = topic
      $scope.onTopicClick()?(topic)

    me: Auth.getCurrentUser()

    queryTags: undefined

    topicsFilter: (item)->
      switch $scope.viewState.filterMethod
        when 'all'
          return true
        when 'createdByMe'
          return item.postBy._id is $scope.me._id
      return true

    deleteTopic: (topic, $event)->
      $event?.stopPropagation()
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        windowClass: 'message-modal'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除帖子'
          message: -> "是否要删除您的帖子：\"#{topic.title}\"，删除后将无法恢复！"
      .result.then ->
        topic.remove()
        .then ()->
          $scope.topics.splice $scope.topics.indexOf(topic), 1

    filterTags: []

    searchByTag: (tag)->
      if $scope.filterTags.indexOf(tag) > -1
        $scope.filterTags.splice $scope.filterTags.indexOf(tag), 1
        tag.$active = false
      else
        $scope.filterTags.push tag
        tag.$active = true

    filterByTags: (item)->
      if $scope.filterTags?.length
        $scope.filterTags.some (tag)->
          item.metadata.tags?.some (x)-> x.name is tag.name
      else
        true

    createTopic: ()->
      # validate
      $modal.open
        templateUrl: 'app/forum/discussionComposerPopup/discussionComposerPopup.html'
        controller: 'DiscussionComposerPopupCtrl'
        windowClass: 'bud-modal'
        resolve:
          topics: -> $scope.topics
        backdrop: 'static'
        keyboard: false

      .result.then (dis_topic)->
        dis_topic.$heat = 1000 / (moment().diff(moment(dis_topic.created),'hours') + 1)+ dis_topic.commentsNum * 10 + dis_topic.likeUsers.length * 10
        $scope.topics.splice 0, 0, dis_topic

  $scope.$watch 'topics', (value)->
    # pull out the tags in content
    if value?.length
      $scope.queryTags = []
      $scope.topics.forEach (topic)->
        $scope.queryTags = $scope.queryTags.concat topic.metadata?.tags
        topic.$heat = 1000 / (moment().diff(moment(topic.created),'hours') + 1)+ topic.commentsNum * 10 + topic.likeUsers.length * 10
      $scope.queryTags = _.compact $scope.queryTags
      $scope.queryTags = _.uniq $scope.queryTags, (x)-> x.srcId
  , true
