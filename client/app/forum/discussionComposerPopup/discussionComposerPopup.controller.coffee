'use strict'

angular.module('budweiserApp').controller 'DiscussionComposerPopupCtrl',
(
  $scope
  $modalInstance
  Restangular
  $modal
  $state
  notify
) ->

  angular.extend $scope,

    close: ->
      if @myTopic.title or @myTopic.content
        $modal.open
          templateUrl: 'components/modal/messageModal.html'
          windowClass: 'message-modal'
          controller: 'MessageModalCtrl'
          resolve:
            title: -> '警告!'
            message: -> "是否放弃编辑？"
        .result.then ->
          $modalInstance.dismiss('close')
      else
        $modalInstance.dismiss('close')

    myTopic: {
      tags: []
    }

    onChange: (text, content)->
      content.$setValidity 'mongoose', text?

    create: (form)->
      $scope.submitted = true
      if !form.$valid then return
      $scope.errors = null
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
        $scope.tags.push
          text: search

    tags: [
        text: 'dog'
      ,
        text: 'cat'
      ,
        text: 'mouse'
    ]

    viewState: {}

    deleteTag: (tag)->
      $scope.myTopic.tags.splice $scope.myTopic.tags.indexOf(tag), 1
