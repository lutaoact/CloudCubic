'use strict'

angular.module('budweiserApp').controller 'DiscussionComposerPopupCtrl',
(
  $scope
  $state
  notify
  Restangular
  messageModal
  $modalInstance
  topic
) ->

  angular.extend $scope,

    close: ->
      if @myTopic.title or @myTopic.content
        messageModal.open
          title: -> '警告!'
          message: -> "是否放弃编辑？"
        .result.then ->
          $modalInstance.dismiss('close')
      else
        $modalInstance.dismiss('close')

    myTopic: topic or {tags: []}

    onChange: (text, content)->
      content.$setValidity 'mongoose', text?

    create: (form)->
      $scope.submitted = true
      if !form.$valid then return
      $scope.errors = null
      @myTopic.forumId = $state.params.forumId
      if @myTopic._id
        @myTopic.put()
        .then (topic)->
          $scope.imagesToInsert = undefined
          $modalInstance.close topic
        , (err) ->
          err = err.data
          $scope.errors = {}
          notify
            message: '创建讨论失败'
            classes: 'alert-danger'
          # Update validity of form fields that match the mongoose errors
          angular.forEach err.errors, (error, field) ->
            form[field].$setValidity 'mongoose', false
            $scope.errors[field] = error.message
      else
        Restangular.all('topics').post @myTopic, {forumId: $state.params.forumId}
        .then (topic)->
          $scope.imagesToInsert = undefined
          $modalInstance.close topic
        , (err) ->
          err = err.data
          $scope.errors = {}
          notify
            message: '创建讨论失败'
            classes: 'alert-danger'
          # Update validity of form fields that match the mongoose errors
          angular.forEach err.errors, (error, field) ->
            form[field].$setValidity 'mongoose', false
            $scope.errors[field] = error.message

    addTag: ($item, search)->
      if $item
        if $scope.myTopic.tags.indexOf($item.text)>-1
          $scope.myTopic.tags.splice $scope.myTopic.tags.indexOf($item.text), 1
        $scope.myTopic.tags.push $item.text
      else if search
        # add to topic tags
        if $scope.myTopic.tags.indexOf(search)>-1
          $scope.myTopic.tags.splice $scope.myTopic.tags.indexOf(search), 1
        $scope.myTopic.tags.push search

        # then add to tag library
        $scope.tags.post
          text: search
        .then (tag)->
          $scope.tags.push tag

    viewState: {}

    deleteTag: (tag)->
      $scope.myTopic.tags.splice $scope.myTopic.tags.indexOf(tag), 1

    editorInit: (api)->
      $scope.editorApi = api
      if $scope.myTopic
        api.setContent($scope.myTopic.content)

  Restangular.all('tags').getList()
  .then (tags)->
    $scope.tags = tags
