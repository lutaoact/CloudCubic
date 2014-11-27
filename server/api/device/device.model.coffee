"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Device = BaseModel.subclass
  classname: 'Device'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type : ObjectId
        required : true
        ref : 'user'
      deviceToken:
        type: String
        required: true

    @schema.index {userId: 1, deviceToken: 1}, {unique: true}

    $super()

  getOne: (userId, deviceToken) ->
    return @findOneQ {userId: userId, deviceToken: deviceToken}

  createOne: (userId, deviceToken) ->
    return @createQ {userId: userId, deviceToken: deviceToken}

  getByUserId: (userId) ->
    return @findQ {userId: userId}
