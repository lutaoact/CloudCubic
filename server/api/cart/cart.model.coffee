'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Cart = BaseModel.subclass
  classname: 'Cart'
  initialize: ($super) ->
    @schema = new Schema
      userId:
        type: ObjectId
        ref: 'user'
        required: true
        unique: true
      classes: [
        type: ObjectId
        ref: 'classe'
      ]

    $super()

  getByUserId: (userId) ->
    return @findOneQ userId: userId
