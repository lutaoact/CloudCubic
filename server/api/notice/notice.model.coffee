'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

populateCommon = [
  path: 'fromWhom', select: 'avatar name'
,
  path: 'data.lectureId', select: 'name'
,
  path: 'data.disTopicId', select: 'title'
,
  path: 'data.courseId', select: 'name'
,
  path: 'data.forumId', select: 'name'
,
  path: 'data.commentId', select: 'content'
]

exports.Notice = BaseModel.subclass
  classname: 'Notice'

  populates:
    create: populateCommon
    index: populateCommon
    
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
      data:
        lectureId:
           type: ObjectId
           ref: 'lecture'
        disTopicId:
           type: ObjectId
           ref: 'dis_topic'
        courseId :
           type : ObjectId
           ref : 'course'
        forumId:
           type : ObjectId
           ref : 'forum'
        commentId:
           type : ObjectId
           ref : 'comment'
      status: Number

    $super()
