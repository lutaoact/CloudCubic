'use strict'

angular.module 'budweiserApp'

.controller 'NavbarCtrl', (
  org
  Auth
  $scope
  $state
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

    switchMenu: (val) ->
      $scope.viewState.isCollapsed = val

    logout: ->
      Msg.clearMsg()
      Auth.logout()
      socket.close()
      $state.go($localStorage.global?.loginState or 'main')

    isActive: (state) ->
      if state
        regex = new RegExp(state)
        regex.test $state.current.name
      else
        false

    displayCourseMenu: ->
      $state.params.courseId && $state.current.name.indexOf('admin') != 0
