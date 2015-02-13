"use strict"

mongoose = require "mongoose"
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Category = BaseModel.subclass
  classname: 'Category'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      orgId:
        type : ObjectId
        required: true
        ref : 'organization'

    @schema
    .path 'name'
    .validate (name, respond) ->
      self = this
      this.constructor.findOne
        name : name
        orgId: self.orgId
      , (err, data) ->
        throw err if err
        notTaken = !data or data.id == self.id
        respond notTaken
    , '该专业名称已被占用，请选择其他名称'

    $super()
