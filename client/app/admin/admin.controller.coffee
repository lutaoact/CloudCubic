'use strict'

angular.module('budweiserApp').controller 'AdminCtrl', (
  $scope
) ->

  angular.extend $scope,
    menus: [
      stateName:'admin.home'
      className: 'budon budon-organization'
      label: '机构信息设置'
    ,
      stateName:'admin.teacherManager'
      className: 'budon budon-teacher'
      label: '教师管理'
    ,
      stateName:'admin.classeManager'
      className: 'budon budon-course-classe'
      label: '开班设置'
    ,
      stateName:'admin.categoryManager'
      className: 'budon budon-category'
      label: '专业课程'
    ,
      stateName:'admin.orderManager'
      className: 'budon budon-pay'
      label: '订单管理'
    ]
