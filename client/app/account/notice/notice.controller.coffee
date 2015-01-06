'use strict'

angular.module('budweiserApp').controller 'NoticeCtrl',(
  Auth
  $scope
  notify
  Restangular
  $rootScope
  Msg
) ->

  angular.extend $scope,
    itemsPerPage: 5
    currentMessagePage: 1
    maxSize: 4

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
        $rootScope.$broadcast 'message.read', message

  Restangular.all('notices').getList({all: true})
  .then (notices)->
    notices.forEach (notice)->
      $scope.messages.splice 0, 0, Msg.genMessage(notice)

