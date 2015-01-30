'use strict'

angular.module('budweiserApp')

.directive 'topicList', ->
  restrict: 'E'
  replace: true
  controller: 'TopicListCtrl'
  templateUrl: 'app/forum/forumDetail/topicList.template.html'
  scope:
    topics: '='
    onTagClick: '&'

.controller 'TopicListCtrl', ($scope, Auth, $modal, Restangular, $state, messageModal)->

  angular.extend $scope,
    params: $state.params

    me: Auth.getCurrentUser

    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 6
      sort         : $state.params.sort ? 'heat'
      keyword      : $state.params.keyword ? undefined
      tags         : if $state.params.tags then JSON.parse($state.params.tags) else []
      createdBy    : $state.params.createdBy

    queryTags: undefined

    deleteTopic: (topic, $event)->
      $event?.stopPropagation()
      messageModal.open
        title: -> '删除帖子'
        message: -> "是否要删除您的帖子：\"#{topic.title}\"，删除后将无法恢复！"
      .result.then ->
        topic.remove()
      .then ()->
        $scope.topics.splice $scope.topics.indexOf(topic), 1

    searchByTag: (tag)->
      if $scope.pageConf.tags.indexOf(tag.text) > -1
        $scope.pageConf.tags.splice $scope.pageConf.tags.indexOf(tag.text), 1
      else
        $scope.pageConf.tags.push tag.text

      $scope.reload(true)

    createTopic: ()->
      # validate
      $modal.open
        templateUrl: 'app/forum/discussionComposerPopup/discussionComposerPopup.html'
        controller: 'DiscussionComposerPopupCtrl'
        windowClass: 'bud-modal'
        backdrop: 'static'
        keyboard: false
      .result.then (topic)->
        $scope.topics.splice 0, 0, topic

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'forum.detail',
        page: $scope.pageConf.currentPage
        keyword: $scope.pageConf.keyword
        sort: $scope.pageConf.sort
        tags: JSON.stringify $scope.pageConf.tags
        createdBy: $scope.pageConf.createdBy

    search: ()->
      sortObj = {}
      if $scope.pageConf.sort is 'heat'
        sortObj.heat = -1
        sortObj.viewersNum = -1
        sortObj.commentsNum = -1
        sortObj.created = -1
      else
        sortObj.created = -1

      Restangular.all('topics').getList
        forumId    : $state.params.forumId
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.pageConf.keyword
        sort       : JSON.stringify sortObj
        tags       : JSON.stringify $scope.pageConf.tags
        createdBy  : $scope.pageConf.createdBy
      .then (topics)->
        $scope.topics = topics
        $scope.topicTotalCount = topics.$count

  $scope.search()

  Restangular.one('forums',$state.params.forumId).all('tagsFreq').getList()
  .then (tagsFreq)->
    $scope.queryTags = tagsFreq
    if $scope.pageConf.tags
      tagsFreq.forEach (tag)->
        if $scope.pageConf.tags.indexOf(tag.text) > -1
          tag.$active = true
