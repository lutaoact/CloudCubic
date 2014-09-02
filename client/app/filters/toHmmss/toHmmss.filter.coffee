'use strict'

angular.module('budweiserApp').filter 'toHmmss', ->
  (input) ->
    if input
      result = input
      input = parseInt(input)
      data = moment.duration(input, 'seconds')._data
      result = [data.hours, ('0' + data.minutes).substring(-1,2), ('0' + data.seconds).substring(-1, 2)].join ':'
      result
