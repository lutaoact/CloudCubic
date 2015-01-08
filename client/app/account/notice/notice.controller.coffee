'use strict'

angular.module('budweiserApp').controller 'NoticeCtrl',(
  Auth
  $scope
  $state
  notify
  Restangular
  $rootScope
  Msg
) ->

  angular.extend $scope,
    pageConf:
      itemsPerPage: 5
      currentPage : $state.params.page ? 1
      maxSize: 4

    messages: []

    markAsRead: (message, $event)->
      $event?.stopPropagation()
      if message.raw.status
        return
      noticeId = message.raw._id
      Restangular.all('notices/read').post ids:[noticeId]
      .then ()->
        message.raw.status = 1
        Msg.readMsg()

    changePage: ()->
      console.log $scope.pageConf.currentPage
      $state.go('settings.notice',
        page     :$scope.pageConf.currentPage
      )

  Restangular.all('notices').getList(
    all: true
    from   : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
    limit  : $scope.pageConf.itemsPerPage
  )
  .then (notices)->
    $scope.messages = []
    notices.forEach (notice)->
      $scope.messages.splice 0, 0, Msg.genMessage(notice)
    $scope.messages.$count = notices.$count
