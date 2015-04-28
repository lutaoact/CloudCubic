'use strict'

angular.module('budweiserApp')

.controller 'OrgMainCtrl', (
  Auth
  $scope
) ->

  angular.extend $scope,
    Auth: Auth
    maxSize: 3
    myInterval: 5000
    banners: [
      {
        image:'http://public-cloud3edu-com.qiniudn.com/cdn/images/banners/1/home_banner03.jpg'
      }
    ]
