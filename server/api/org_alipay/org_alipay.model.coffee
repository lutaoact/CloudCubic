"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.OrgAlipay = BaseModel.subclass
  classname: 'OrgAlipay'
  initialize: ($super) ->
    @schema = new Schema
      orgId:
        type : ObjectId
        required: true
        ref : 'organization'
      PID:
        type: String
        required: true
      key:
        type: String
        required: true
      email:
        type: String
        required: true

    $super()

  findByOrgId: (orgId) ->
    @findOneQ orgId: orgId

  findByOrgIdLean: (orgId) ->
    @findOne orgId: orgId
    .lean()
    .execQ()