'use strict'

angular.module('budweiserApp')

.config ($stateProvider) ->

  $stateProvider.state 'about',
    url: '/about'
    templateUrl: 'app/about/about.html'
