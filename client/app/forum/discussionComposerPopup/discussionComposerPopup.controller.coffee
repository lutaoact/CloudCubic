'use strict'

angular.module('budweiserApp').controller 'DiscussionComposerPopupCtrl',
(
  $scope
  $modalInstance
  Restangular
  $modal
) ->

  angular.extend $scope,

    close: ->
      if @myTopic.title or @myTopic.content
        $modal.open
          templateUrl: 'components/modal/messageModal.html'
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
      Restangular.all('dis_topics').post @myTopic, {courseId: course._id}
      .then (dis_topic)->
        $scope.imagesToInsert = undefined
        $modalInstance.close dis_topic

    viewState: {}

    deleteTag: (tag)->
      $scope.myTopic.metadata.tags.splice $scope.myTopic.metadata.tags.indexOf(tag), 1




