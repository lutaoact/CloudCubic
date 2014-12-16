'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.DisTopic = BaseModel.subclass
  classname: 'DisTopic'
  initialize: ($super) ->
    @schema = new Schema
      postBy:
        type: ObjectId
        ref: 'user'
        required: true
      # 板块名称
      name:
        type: String
        required: true
      # 板块logo
      logo:
        type: String
      # 板块描述
      info:
        type: String
      # 帖子总数（定时任务产生）
      postsCount:
        type: Number
        required: true
        default: 0
      # 新增帖子数（定时任务产生）
      recentPostsCount:
        type: Number
        required: true
        default: 0
    $super()
