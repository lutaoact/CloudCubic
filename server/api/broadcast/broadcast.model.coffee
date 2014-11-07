'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

exports.Broadcast = BaseModel.subclass
  classname: 'Broadcast'
  initialize: ($super) ->
    @schema = new Schema
      org:
        type: ObjectId
        ref: 'user'
        required: true
      title:
        type: String
        required: true
      content:
        type: String
        required: true

    $super()
