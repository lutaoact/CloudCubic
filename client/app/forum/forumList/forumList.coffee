'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum.list',
    url: '/'
    templateUrl: 'app/forum/forumList/forumList.html'
    controller: 'ForumListCtrl'

