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

  generateCategories = ()->

    $q.all(_.uniq(_.pluck($scope.forums, 'categoryId')).map (categoryId)->
      if categoryId?._id
        Category.find(categoryId._id)
      else
        null
    )
    .then (categories)->
      categories = categories.filter (category)->
        category?
      $scope.forumCategories = [{name:'全部'}].concat(categories).concat([{_id:'',name:'其他'}])
      $scope.viewState.forumsFilters.category = $scope.forumCategories[0]

  Restangular.all('forums').getList()
  .then (forums)->
    $scope.forums = forums
    generateCategories()

  angular.extend $scope,
    itemsPerPage: 6
    currentForumPage: 1
    maxSize: 5
    viewState:
      forumsFilters:
        category: null

    createForum: ()->
      $modal.open
        templateUrl: 'app/forum/editForum/editForumModal.html'
        controller: 'EditForumModalCtrl'
        resolve:
          forum: ->
            name: ''
      .result.then (newForum) ->
        $scope.forums.push newForum

  $scope.$on 'forum.deleted', (event, forum)->
    $scope.forums.splice($scope.forums.indexOf(forum),1)





