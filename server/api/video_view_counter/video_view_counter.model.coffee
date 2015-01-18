'use strict'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = require('../../common/BaseModel').BaseModel

exports.VideoViewCounter = BaseModel.subclass
  classname: 'VideoViewCounter'
  initialize: ($super) ->
    @schema = new Schema
      userId :
        type : ObjectId
        required : true
        ref : 'user'
      mediaKey: String
      counter :
        type : Number
        required : true
        default : 0

    @schema.index {userId: 1, mediaKey: 1}, {unique: true}

    $super()

