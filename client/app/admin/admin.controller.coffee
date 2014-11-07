'use strict'

angular.module('budweiserApp').controller 'AdminCtrl', (
  $scope
  webview
) ->

  angular.extend $scope,
    webview: webview
    menus: [
      stateName:'admin.home'
      className: 'fa fa-home'
      label: '机构管理'
    ,
      stateName:'admin.teacherManager'
      className: 'fa fa-user'
      label: '教师管理'
    ,
      stateName:'admin.classeManager'
      className: 'fa fa-group'
      label: '班级和学生'
    ,
      stateName:'admin.categoryManager'
      className: 'fa fa-book'
      label: '专业管理'
    ]

