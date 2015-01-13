'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.detail',
    url: '/:forumId/topics?page&keyword&sort&tags&createdBy'
    templateUrl: 'app/forum/forumDetail/forumDetail.html'
    controller: 'ForumDetailCtrl'


