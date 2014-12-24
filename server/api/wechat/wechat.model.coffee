'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Wechat = BaseModel.subclass
  classname: 'Wechat'

  initialize: ($super) ->
    @schema = new Schema
      content: {}

    $super()
