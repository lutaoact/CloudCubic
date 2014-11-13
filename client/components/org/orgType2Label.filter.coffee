'use strict'

angular.module('budweiserApp')

.filter 'orgType2Label', (orgTypeService) ->
  (item) ->
    _.find(orgTypeService.getList(), value: parseInt(item))?.label
