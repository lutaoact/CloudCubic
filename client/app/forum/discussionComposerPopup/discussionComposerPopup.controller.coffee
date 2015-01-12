'use strict'

angular.module('budweiserApp').controller 'DiscussionComposerPopupCtrl',
(
  $scope
  $modalInstance
  Restangular
  $modal
  $state
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

    myTopic:
      metadata:
        postType: '提问'

    create: ()->
      Restangular.all('dis_topics').post @myTopic, {forumId: $state.params.forumId}
      .then (dis_topic)->
        $scope.imagesToInsert = undefined
        $modalInstance.close dis_topic

    viewState: {}

    deleteTag: (tag)->
      $scope.myTopic.metadata.tags.splice $scope.myTopic.metadata.tags.indexOf(tag), 1
