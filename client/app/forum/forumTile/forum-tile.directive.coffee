'use strict'

angular.module('budweiserApp').directive 'forumTile', ()->
  templateUrl: 'app/forum/forumTile/forum-tile.html'
  restrict: 'E'
  replace: true
  scope:
    forum: '='

  controller: ($scope, Auth, $modal)->
    angular.extend $scope,
      getMe: Auth.getCurrentUser

      editForum: (forum)->
        $modal.open
          templateUrl: 'app/forum/editForum/editForumModal.html'
          controller: 'EditForumModalCtrl'
          resolve:
            forum: ->
              forum
        .result.then (newForum) ->
          console.log newForum

      deleteCallback: (forum) ->
        $scope.$emit 'forum.deleted', forum

      deleteForum: (forum)->
        forum = $scope.forum
        $modal.open
          templateUrl: 'components/modal/messageModal.html'
          controller: 'MessageModalCtrl'
          resolve:
            title: -> '删除讨论组'
            message: -> "确认要删除《#{forum.name}》？"
        .result.then ->
          forum.remove()
        .then ->
          $scope.deleteCallback?($forum:forum)
