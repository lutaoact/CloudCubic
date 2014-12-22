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
  Msg
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
    messages: Msg.messages
    getTitle: Navbar.getTitle
    getVisible: Navbar.getVisible

    switchMenu: (val) ->
      $scope.viewState.isCollapsed = val

    logout: ->
      Auth.logout()
      socket.close()
      $state.go($localStorage.global?.loginState or 'main')

    goHome: ->
      currentUser = Auth.getCurrentUser()
      homeStateName =
        if currentUser?.role is 'admin' && $state.includes 'admin'
          'admin.home'
        else
          'main'
      $state.go homeStateName

    isActive: (state) ->
      $state.is state?.replace(/\(.*?\)/g, '')

    clearAll: ()->
      if $scope.messages.length
        Restangular.all('notices/read').post ids: _.map $scope.messages, (x)-> x.raw._id
        .then ()->
          $scope.messages.length = 0

    removeMsg: (message, $event)->
      # for only reload the topicDetail directive when we are just on this forum page.
      $rootScope.$broadcast("forum/reloadReplyList", message.raw.data?.disReply?._id)

      $event?.stopPropagation()
      noticeId = message.raw._id
      Restangular.all('notices/read').post ids:[noticeId]
      .then ->
        $scope.messages.splice $scope.messages.indexOf(message), 1

    openCalendar: ()->
      $modal.open
        templateUrl: 'app/calendar/calendar-popup.html'
        controller: 'CalendarPopupCtrl'

    displayCourseMenu: ->
      $state.params.courseId && $state.current.name.indexOf('admin') != 0


  $scope.$on 'message.notice', (event, data)->
    Msg.genMessage(data).then (msg)->
      $scope.messages.splice 0, 0, msg

