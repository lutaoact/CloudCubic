"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.ActiveTime = BaseModel.subclass
  classname: 'ActiveTime'
  initialize: ($super) ->
    @schema = new Schema
      orgId:
        type : ObjectId
        required: true
        ref : 'organization'
      userId:
        type : ObjectId
        required: true
        ref : 'user'
      date:
        type: Date
        required: true
      activeTime:
        type: Number
        required: true

    $super()
