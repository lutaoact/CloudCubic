'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'admin.reporting',
    url: '/reporting?type&month'
    templateUrl: 'app/admin/reporting/reporting.html'
    controller: 'ReportingCtrl'
    roleRequired: 'admin'

