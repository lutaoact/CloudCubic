'use strict'

angular.module('budweiserApp').config ($stateProvider) ->

  $stateProvider.state 'superuser.home',
    url: '/home'
    templateUrl: 'app/superuser/superuserHome/superuserHome.html'
    controller: 'SuperuserHomeCtrl'
    authenticate: true
