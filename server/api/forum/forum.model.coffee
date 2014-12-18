'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Forum = BaseModel.subclass
  classname: 'Forum'
  initialize: ($super) ->
    @schema = new Schema
      postBy:
        type: ObjectId
        ref: 'user'
        required: true
      name: # 板块名称
        type: String
        required: true
      orgId:
        type: ObjectId
        ref: 'organization'
        required: true
      logo: # 板块logo
        type: String
      info: # 板块描述
        type: String
      postsCount: # 帖子总数（定时任务产生）
        type: Number
        required: true
        default: 0
      recentPostsCount: # 新增帖子数（定时任务产生）
        type: Number
        required: true
        default: 0
      deleteFlag:
        type: Boolean
        default: false

    $super()
