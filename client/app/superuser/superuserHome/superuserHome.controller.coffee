'use strict'

angular.module('budweiserApp')

.controller 'SuperuserHomeCtrl', (
  $scope
  $state
  Organizations
  Restangular
) ->

  angular.extend $scope,
    organizations: Organizations
    wechatMsgs : []

  $scope.$on '$stateChangeSuccess', (event, toState) ->
    if toState.name == 'superuser.home'
      $state.go('superuser.home.organization', orgId:Organizations[0]?._id)

  Restangular.all('wechats/list').getList()
  .then (wechats)->
    wechats.forEach (msg) ->
      createTime = moment.unix parseInt(msg.content.CreateTime)
      element =
        createTime : createTime.format 'YYYY MMMM Do dddd, a h:mm:ss'
        content : msg.content
      $scope.wechatMsgs.push(element)
