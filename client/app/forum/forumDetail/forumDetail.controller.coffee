'use strict'

angular.module('budweiserApp').controller 'ForumDetailCtrl', (
  $q
  $scope
  $state
  Navbar
  Restangular
  Auth
) ->

  if !$state.params.forumId then return

  $q.all [
    Restangular.all('dis_topics').getList({forumId: $state.params.forumId})
    .then (topics)->
      $scope.topics = topics
  ,
    Restangular.one('forums',$state.params.forumId).get()
    .then (forum)->
      $scope.forum = forum
  ]
  .then ->
    $scope.loading = false

  angular.extend $scope,
    me: Auth.getCurrentUser
    myTopic: null
    loading: true
    posting: false
    selectedTopic: undefined

    viewTopic: (topic)->
      $state.go 'forum.topic',
        forumId: $scope.forum._id
        topicId: topic._id
