'use strict'

angular.module('budweiserApp').filter 'timeToTimeAgo', ->
  (input) ->
    moment(new Date(String(input))).fromNow()
