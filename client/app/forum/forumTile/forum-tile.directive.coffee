'use strict'

angular.module('budweiserApp').directive 'forumTile', ()->
  templateUrl: 'app/forum/forumTile/forum-tile.html'
  restrict: 'E'
  replace: true
  scope:
    forum: '='

  controller: ($scope, Auth, $modal, $http, messageModal)->
    angular.extend $scope,
      getMe: Auth.getCurrentUser

      editForum: (forum)->
        $modal.open
          templateUrl: 'app/forum/editForum/editForumModal.html'
          controller: 'EditForumModalCtrl'
          windowClass: 'bud-modal'
          size: 'sm'
          resolve:
            forum: -> angular.copy(forum)
        .result.then (newForum) ->
          angular.extend forum, newForum
        true

      deleteCallback: (forum) ->
        $scope.$emit 'forum.deleted', forum

      deleteForum: (forum)->
        forum = $scope.forum
        messageModal.open
          title: -> '删除讨论组'
          message: -> "确认要删除《#{forum.name}》？"
        .result.then ->
          forum.remove()
        .then ->
          $scope.deleteCallback?(forum)

      stopPropagation: ($event)->
        $event.stopPropagation()
