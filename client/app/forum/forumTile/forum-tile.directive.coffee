'use strict'

angular.module('budweiserApp').directive 'forumTile', ()->
  templateUrl: 'app/forum/forumTile/forum-tile.html'
  restrict: 'E'
  replace: true
  scope:
    forum: '='
