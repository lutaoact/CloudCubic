"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Order = BaseModel.subclass
  classname: 'Order'
  initialize: ($super) ->
    @schema = new Schema
      outTradeNo: #subdomain in cloud3edu
        type : String
        required : true
        unique : true
      tradeNo:
        type: String
      userId:
        type: Schema.Types.ObjectId
        ref: 'user'
        required : true
      classes: [
        type: Schema.Types.ObjectId
        ref: 'classe'
        required : true
      ]
      status:  # unpaid, failed, success
        type : String
        unique : true
        required: true

    $super()
