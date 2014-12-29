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
      type: Number #参考Const中的定义
      data:
        lecture:
           type: ObjectId
           ref: 'lecture'
        disTopic:
           type: ObjectId
           ref: 'dis_topic'
        disReply:
           type: ObjectId
           ref: 'dis_reply'
        course :
           type : ObjectId
           ref : 'course'
      status: Number

    $super()
