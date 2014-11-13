'use strict'

angular.module('budweiserApp').filter 'genColor', ->
  (str) ->
    str = utf8.encode str.toString()
    r = 256 - str.substr(-1,1).charCodeAt()
    g = 256 - str.substr(-5,1).charCodeAt()
    b = 256 - str.substr(-9,1).charCodeAt()
    'rgb(' + [r,g,b].join() + ')'
