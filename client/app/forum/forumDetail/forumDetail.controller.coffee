'use strict'

angular.module('budweiserApp').controller 'ForumDetailCtrl', (
  $q
  $scope
  $state
  Restangular
  Auth
) ->

  if !$state.params.forumId then return


  Restangular.one('forums',$state.params.forumId).get()
  .then (forum)->
    $scope.forum = forum
    $scope.loading = false

  angular.extend $scope,
    me: Auth.getCurrentUser
    myTopic: null
    loading: true
    posting: false
    selectedTopic: undefined


