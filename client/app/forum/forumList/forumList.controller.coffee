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

    $q.all(_.uniq(_.pluck(_.pluck($scope.forums, 'categoryId').filter((x)-> x?),'_id')).map (id)->
      if id
        Category.find(id)
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

    categoryFilter: (item)->
      if !$scope.viewState.forumsFilters.category._id?
        true
      else if $scope.viewState.forumsFilters.category._id is ''
        !item.categoryId?
      else
        item.categoryId?._id is $scope.viewState.forumsFilters.category._id

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





