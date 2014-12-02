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
      deviceType:
        type: Number   # 0: ios; 1: android (baidu userId)
        required: true

    @schema.index {userId: 1, deviceToken: 1}, {unique: true}

    $super()

  getOne: (deviceToken, deviceType) ->
    return @findOneQ {deviceToken: deviceToken, deviceType: deviceType}

  createOne: (userId, deviceToken, deviceType) ->
    return @createQ {userId: userId, deviceToken: deviceToken, deviceType: deviceType}

  getByUserId: (userId) ->
    return @findQ {userId: userId}
