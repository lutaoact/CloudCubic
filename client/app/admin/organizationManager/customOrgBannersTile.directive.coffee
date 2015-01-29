angular.module('budweiserApp')

.directive 'customOrgBannersTile', ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/admin/organizationManager/customOrgBannersTile.html'
  controller: 'CustomOrgBannersTileCtrl'
  scope:
    organization: '='

.controller 'CustomOrgBannersTileCtrl', (
  org
  $scope
  notify
  Restangular
  messageModal
) ->

  saveBanners = (banners, onSuccess, onFailed) ->
    Restangular
    .one('organizations', $scope.organization._id)
    .patch(banners: banners)
    .then (data) ->
      org.banners = data.banners
      onSuccess?(data)
    .catch(onFailed)

  angular.extend $scope,

    onBannerUpload: (key) ->
      banner =
        image: key
        text: ''
      banners = angular.copy $scope.organization.banners
      banners ?= []
      banners.push banner
      saveBanners banners
      , (data) ->
        $scope.organization.banners.push(banner)
        notify
          message: '横幅添加成功'
          classes: 'alert-success'
      , (error) ->
        notify
          message: '横幅添加失败'
          classes: 'alert-danger'

    removeBanner: (banner) ->
      messageModal.open
        title: -> '删除横幅'
        message: -> "确认要删除这个横幅？"
      .result.then ->
        banners = angular.copy $scope.organization.banners
        index = $scope.organization.banners.indexOf(banner)
        banners.splice(index, 1)
        saveBanners banners
        , (data) ->
          $scope.organization.banners.splice(index, 1)
          notify
            message: '横幅已被移除'
            classes: 'alert-success'
        , (error) ->
          notify
            message: '横幅移除失败'
            classes: 'alert-danger'

    saveBanners: ->
      saveBanners $scope.organization.banners
      , (data) ->
        notify
          message: '横幅已保存'
          classes: 'alert-success'
      , (error) ->
        notify
          message: '横幅保存失败'
          classes: 'alert-danger'
