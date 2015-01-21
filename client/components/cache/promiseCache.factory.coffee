angular.module('budweiserApp')

.factory 'PromiseCache', (
  Restangular
) ->

  makePromiseExecutor = (promise) ->
    (onSuccess, onError, onFinally) ->
      promise
      .then(onSuccess)
      .catch(onError)
      .finally(onFinally)

  # 刷新 promise 并缓存起来以便之后直接调用
  refresh: -> angular.extend @,
    checkWeixin: makePromiseExecutor Restangular.one('org_weixins', 'isSet').get()
 


