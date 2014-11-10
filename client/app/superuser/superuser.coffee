'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'superuser',
    url: '/su'
    templateUrl: 'app/superuser/superuser.html'
    controller: 'SuperuserCtrl'
    abstract: true
