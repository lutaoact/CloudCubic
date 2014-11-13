'use strict'

angular.module('budweiserApp')

.service 'orgTypeService', ->

#  Primary     : 1  # 小学
#  JuniorMiddle: 2  # 初中
#  HighMiddle  : 3  # 高中
#  University  : 4  # 大学
#  College    : 5  # 职业学校
#  Institute   : 6  # 培训机构
#  Company     : 7  # 企业
#  Other       : 10 # 其他
  this.getList = ->
    [
      label: "小学"
      value: Const.OrgType.Primary
    ,
      label: "初中"
      value: Const.OrgType.JuniorMiddle
    ,
      label: "高中"
      value: Const.OrgType.HighMiddle
    ,
      label: "大学"
      value: Const.OrgType.University
    ,
      label: "职业学校"
      value: Const.OrgType.College
    ,
      label: "培训机构"
      value: Const.OrgType.Institute
    ,
      label: "企业"
      value: Const.OrgType.Company
    ,
      label: "其他"
      value: Const.OrgType.Other
    ]
  return

