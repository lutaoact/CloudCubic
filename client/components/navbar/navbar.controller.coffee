'use strict'

angular.module 'budweiserApp'

.factory 'Navbar', ->
  title = null
  getTitle: -> title
  setTitle: (name, link) ->
    title =
      name: name
      link: link
  resetTitle: ->
    title = null

.controller 'NavbarCtrl', (
  org
  Auth
  $scope
  $state
  Navbar
  socket
  $rootScope
  Restangular
  $localStorage
  $modal
) ->

  angular.extend $scope,
    org: org
    $state: $state
    viewState:
      isCollapsed: true
    Auth: Auth
    unreadMsgCount: 0
    getTitle: Navbar.getTitle
    getVisible: Navbar.getVisible

    switchMenu: (val) ->
      $scope.viewState.isCollapsed = val

    logout: ->
      Auth.logout()
      socket.close()
      $state.go($localStorage.global?.loginState or 'main')

    isActive: (state) ->
      $state.is state?.replace(/\(.*?\)/g, '')

#    clearAll: ()->
#      if $scope.messages.length
#        Restangular.all('notices/read').post ids: _.map $scope.messages, (x)-> x.raw._id
#        .then ()->
#          $scope.messages.length = 0
#
#    removeMsg: (message, $event)->
#      # for only reload the topicDetail directive when we are just on this forum page.
#      $rootScope.$broadcast("forum/reloadReplyList", message.raw.data?.disReply?._id)
#
#      $event?.stopPropagation()
#      noticeId = message.raw._id
#      Restangular.all('notices/read').post ids:[noticeId]
#      .then ->
#        $scope.messages.splice $scope.messages.indexOf(message), 1

    displayCourseMenu: ->
      $state.params.courseId && $state.current.name.indexOf('admin') != 0

  $scope.$on 'message.notice', ->
    $scope.unreadMsgCount += 1

  $scope.$on 'message.read', ->
    $scope.unreadMsgCount -= 1

  Restangular.all('notices').customGET('unreadCount')
  .then (data)->
    $scope.unreadMsgCount = data.unreadCount
    Tinycon.setBubble($scope.unreadMsgCount)

  $scope.$watch 'unreadMsgCount', ->
    Tinycon.setBubble($scope.unreadMsgCount);
