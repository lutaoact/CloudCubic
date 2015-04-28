'use strict'

angular.module('budweiserApp').controller 'AdminCtrl', (
  $scope
) ->

  angular.extend $scope,
    menus: [
      stateName:'admin.orgManager'
      className: 'budon budon-organization'
      label: '机构信息设置'
    ,
      stateName:'admin.teacherManager'
      className: 'budon budon-teacher'
      label: '教师管理'
    ,
      stateName:'admin.studentManager'
      className: 'budon budon-user'
      label: '学生管理'
    ,
      stateName:'admin.categoryManager'
      className: 'budon budon-category'
      label: '专业管理'
    ,
      stateName:'admin.orderManager'
      className: 'budon budon-pay'
      label: '订单管理'
    ,
      stateName:'admin.reporting'
      className: 'budon budon-pay'
      label: '每月报表'
    ]
