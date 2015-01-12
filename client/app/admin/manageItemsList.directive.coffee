'use strict'

angular.module('budweiserApp')

.directive 'manageItemsList', ->
  restrict: 'EA'
  replace: true
  controller: 'ManageItemsListCtrl'
  templateUrl: 'app/admin/manageItemsList.html'
  scope:
    items: '='
    other: '='
    children: '@'
    itemType: '@'
    activeItem: '='
    onAddBtnClicked: '&'
    onCreateItem: '&'
    onDeleteItems: '&'
    onViewItem: '&'

.controller 'ManageItemsListCtrl', (
  $modal
  $state
  $scope
  notify
  Restangular
) ->

  updateSelected = ->
    $scope.selectedItems =  _.filter($scope.items, '$selected':true)

  angular.extend $scope,
    $state: $state
    currentPage: 1
    selectedItem: null
    selectedItems: []
    itemTitle:
      switch $scope.itemType
        when 'classes'    then '开课班级'
        when 'categories' then '专业'
        else throw Error('unknown itemType ' + $scope.itemType)

    deleteItems: (selectedItems) ->
      $modal.open
        templateUrl: 'components/modal/messageModal.html'
        controller: 'MessageModalCtrl'
        windowClass: 'message-modal'
        size: 'sm'
        resolve:
          title: -> "删除#{$scope.itemTitle}"
          message: ->
            """确认要删除这#{selectedItems.length}个#{$scope.itemTitle}？"""
      .result.then ->
        $scope.deleting = true
        Restangular.all($scope.itemType).customPOST(ids: _.pluck(selectedItems, '_id'), 'multiDelete')
        .then ->
          $scope.deleting = false
          $scope.onDeleteItems?($items:selectedItems)

    createNewItem: ->
      $scope.onAddBtnClicked?() or $modal.open
        templateUrl: 'app/admin/newItemModal.html'
        controller: 'NewItemModalCtrl'
        windowClass: 'new-item-modal'
        size: 'sm'
        resolve:
          itemType: -> $scope.itemType
          itemTitle: -> $scope.itemTitle
      .result.then (newItem) ->
        $scope.onCreateItem?($item:newItem)
        notify
          message: "新#{$scope.itemTitle}添加成功"
          classes: 'alert-success'

    viewItem: (item) ->
      $scope.onViewItem?($item:item)

    isSelectedAll: (currentItems) ->
      _.filter(currentItems, '$selected':true).length == currentItems?.length

    toggleSelect: (items, selected) ->
      angular.forEach items, (o) -> o.$selected = selected
      updateSelected()

  $scope.$watch 'items.length', updateSelected
