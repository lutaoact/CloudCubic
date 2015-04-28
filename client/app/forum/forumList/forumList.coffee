'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.list',
    url: '?page&keyword&sort'
    templateUrl: 'app/forum/forumList/forumList.html'
    controller: 'ForumListCtrl'

