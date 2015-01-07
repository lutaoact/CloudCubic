angular.module('budweiserApp')

.filter 'objectId', ->
  (object) -> object?._id ? object
