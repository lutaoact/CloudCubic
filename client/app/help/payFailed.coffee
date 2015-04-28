'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'helpPayFailed',
    url: '/help/payFailed'
    templateUrl: 'app/help/payFailed.html'
#    controller: 'payFailedCtrl'
