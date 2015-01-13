'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Tag = BaseModel.subclass
  classname: 'Tag'
  initialize: ($super) ->
    @schema = new Schema
      orgId:
        type: ObjectId
        ref: 'organization'
        required: true
      text:
        type: String
        required: true

    @schema.index {orgId: 1, text: 1}, {unique: true}

    $super()
