'use strict'

angular.module('budweiserApp')

.directive 'comments', ->
  restrict: 'E'
  replace: true
  controller: 'CommentsCtrl'
  templateUrl: 'app/comment/comments.html'
  scope:
    belongTo: '='
    extra: '='
    activeComment: '='
    type: '@'

.controller 'CommentsCtrl', ($scope, Auth, Restangular, $timeout, $document, $state, $modal)->
  if !$scope.type
    throw 'should define type of comments directive'
  angular.extend $scope,

    me: Auth.getCurrentUser

    newComment: {}
    commenting: false

    createComment: ()->
      # validate
      @commenting = true
      @newComment.type = parseInt($scope.type)
      if !$scope.belongTo
        throw 'should define belongTo'
      $scope.newComment.belongTo = $scope.belongTo
      $scope.newComment.extra = $scope.extra
      Restangular.all('comments').post $scope.newComment
      .then (comment)->
        $scope.comments.splice 0, 0, comment
        $scope.initMyComment()
        $scope.commenting = false
        $scope.activeComment = comment._id
        $scope.$emit 'comments.number', $scope.comments.length

    initMyComment: ()->
      @newComment = {} if !@newComment
      @newComment.type = parseInt($scope.type)
      @newComment.content = ''

    toggleLike: (comment)->
      comment.one('like').post()
      .then (res)->
        comment.likeUsers = res.likeUsers

    deleteComment: (comment)->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        windowClass: 'message-modal'
        controller: 'MessageModalCtrl'
        resolve:
          title: -> '删除评论？'
          message: -> "删除后将无法恢复！"
      .result.then ->
        comment.remove()
        .then ()->
          $scope.comments.splice $scope.comments.indexOf(comment), 1

    commentsFilter: (item)->
      switch $scope.viewState.filterMethod
        when 'all'
          return true
        when 'createdByMe'
          return item.postBy._id is $scope.me()._id
      return true

    scrollToEditor: ()->
      $document.scrollToElement(angular.element('.new-comment-right'), 200, 200)

  $scope.$watch 'belongTo', (value)->
    if value
      Restangular.all('comments').getList(belongTo:$scope.belongTo)
      .then (comments)->
        $scope.comments = comments
        $scope.$emit 'comments.number', comments.length

  $scope.$watch 'activeComment', (value)->
    if value
      $timeout ->
        targetElement = angular.element(document.getElementById value)
        targetElement.addClass('active')
        windowHeight = $(window).height();
        $document.scrollToElement(targetElement, windowHeight/2, 500)
        $timeout ->
          targetElement.removeClass('active')
        , 1000
      , 100
