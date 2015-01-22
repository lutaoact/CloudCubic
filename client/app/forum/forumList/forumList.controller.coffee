'use strict'

angular.module('budweiserApp').controller 'ForumListCtrl', (
  $q
  $scope
  $state
  Navbar
  Auth
  Restangular
  Category
  $modal
) ->

  angular.extend $scope,

    Auth: Auth

    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 6
      sort         : $state.params.sort ? 'postsCount'

    viewState:
      keyword: $state.params.keyword ? ''

    createForum: ()->
      $modal.open
        templateUrl: 'app/forum/editForum/editForumModal.html'
        controller: 'EditForumModalCtrl'
        windowClass: 'bud-modal'
        size: 'sm'
        resolve:
          forum: ->
            name: ''
      .result.then (newForum) ->
        $scope.forums.push newForum

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'forum.list',
        page: $scope.pageConf.currentPage
        keyword: $scope.viewState.keyword
        sort: $scope.pageConf.sort

    search: ()->
      sortObj = {}
      if $scope.pageConf.sort
        sortObj[$scope.pageConf.sort] = -1
      sortObj.created = -1
      Restangular.all('forums').getList
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.viewState?.keyword
        sort       : JSON.stringify sortObj
      .then (forums)->
        $scope.forums = forums

  $scope.search()
  .then (forums)->
    $scope.forumsTotalCount = forums.$count

  $scope.$on 'forum.deleted', (event, forum)->
    $scope.forums.splice($scope.forums.indexOf(forum),1)

