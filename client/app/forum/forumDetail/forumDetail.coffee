'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.detail',
    url: '/:forumId/topics'
    templateUrl: 'app/forum/forumDetail/forumDetail.html'
    controller: 'ForumDetailCtrl'


