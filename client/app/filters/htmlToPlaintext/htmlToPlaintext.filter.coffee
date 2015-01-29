'use strict'

angular.module('budweiserApp').filter 'htmlToPlaintext', ->
  (input) ->
    input?.replace(/<[^>]+>/gm, '')

