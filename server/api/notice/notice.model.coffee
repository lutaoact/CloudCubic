'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

exports.Notice = BaseModel.subclass
  classname: 'Notice'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        ref: 'user'
        required: true
      fromWhom:
        type: ObjectId
        ref: 'user'
      type: Number #参考Const.NoticeType中的定义
#      title: String
      data:
        lectureId:
           type: ObjectId
           ref: 'lecture'
        disTopicId:
           type: ObjectId
           ref: 'dis_topic'
        disReplyId:
           type: ObjectId
           ref: 'dis_reply'
        courseId :
           type : ObjectId
           ref : 'course'
        forumId:
           type : ObjectId
           ref : 'forum'
      status: Number

    $super()
