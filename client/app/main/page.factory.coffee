'use strict'

angular.module('budweiserApp')

.factory 'Page', ($document) ->

  setTitle: (newTitle) ->
    $document[0].title = newTitle
