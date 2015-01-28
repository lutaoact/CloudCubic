angular.module('budweiserApp')

.directive 'customOrgBannersTile', ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/admin/organizationManager/customOrgBannersTile.html'
  controller: 'CustomOrgBannersTileCtrl'
  scope:
    organization: '='

.controller 'CustomOrgBannersTileCtrl', (
  $scope
  notify
  Restangular
  org
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
          message: 'banner 添加成功'
          classes: 'alert-success'
      , (error) ->
        notify
          message: 'banner 添加失败'
          classes: 'alert-danger'

    removeBanner: (banner) ->
      banners = angular.copy $scope.organization.banners
      index = $scope.organization.banners.indexOf(banner)
      banners.splice(index, 1)
      saveBanners banners
      , (data) ->
        $scope.organization.banners.splice(index, 1)
        notify
          message: 'banner 已被移除'
          classes: 'alert-success'
      , (error) ->
        notify
          message: 'banner 移除失败'
          classes: 'alert-danger'

    saveBanners: ->
      saveBanners $scope.organization.banners
      , (data) ->
        notify
          message: 'banner 已保存'
          classes: 'alert-success'
      , (error) ->
        notify
          message: 'banner 保存失败'
          classes: 'alert-danger'
