"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.OrgWeixin = BaseModel.subclass
  classname: 'OrgWeixin'
  initialize: ($super) ->
    @schema = new Schema
      orgId:
        type : ObjectId
        required: true
        unique: true
        ref : 'organization'
      domain:
        type: String
        required: true
        unique: true
      appid:
        type: String
        required: true
      secret:
        type: String
        required: true
      gongappid:
        type: String
        required: true
      gongsecret:
        type: String
        required: true

    $super()
