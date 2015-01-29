angular.module('budweiserApp')

.factory 'PromiseCache', (
  Restangular
) ->

  orgWeixinPromise = null

  # 刷新缓存的 promise
  refresh: ->
    orgWeixinPromise = Restangular.one('org_weixins', 'isSet').get()

  checkWeixin: -> orgWeixinPromise
