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
  Msg
) ->

  angular.extend $scope,
    org: org
    $state: $state
    viewState:
      isCollapsed: true
    Auth: Auth
    getMsgCount: Msg.getMsgCount
    unreadMsgCount: 0
    getTitle: Navbar.getTitle
    getVisible: Navbar.getVisible

    switchMenu: (val) ->
      $scope.viewState.isCollapsed = val

    logout: ->
      Msg.clearMsg()
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
    displayCourseMenu: ->
      $state.params.courseId && $state.current.name.indexOf('admin') != 0
