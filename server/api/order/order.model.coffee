"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Order = BaseModel.subclass
  classname: 'Order'
  initialize: ($super) ->
    @schema = new Schema
    # use _id instead of outTradeNo
#      outTradeNo: #subdomain in cloud3edu
#        type : String
#        required : true
#        unique : true
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
      totalFee:
        type: Number
        required : true
      status:  # unpaid, failed, succeed, invalid
        type : String
        required: true

    $super()
