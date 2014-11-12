'use strict'

angular.module('budweiserApp').controller 'NoticeCtrl',(
  Auth
  $scope
  notify
  Restangular
  Msg
) ->

  angular.extend $scope,

    broadcasts: undefined

    messages: []

    viewState: {}

    markAsRead: (message, $event)->
      $event?.stopPropagation()
      if message.raw.status
        return
      noticeId = message.raw._id
      Restangular.all('notices/read').post ids:[noticeId]
      .then ()->
        message.raw.status = 1

  Restangular.all('notices').getList({all: true})
  .then (notices)->
    notices.forEach (notice)->
      Msg.genMessage(notice).then (msg)->
        $scope.messages.splice 0, 0, msg

  Restangular.all('broadcasts').getList()
  .then (broadcasts)->
    $scope.broadcasts = broadcasts
