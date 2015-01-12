'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
Mixed = Schema.Types.Mixed

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Comment = BaseModel.subclass
  classname: 'Comment'
  populates:
    index: [
      path: 'postBy', select: 'name avatar'
    ]
    create: [
      path: 'postBy', select: 'name avatar'
    ]

  initialize: ($super) ->
    @schema = new Schema
      content:
        type: String
        required: true
      postBy:
        type: ObjectId
        ref: 'user'
        required: true
      type:
        type: Number
        required: true
      belongTo:
        type: ObjectId
        required: true
      likeUsers: [
        type: ObjectId
        ref: 'user'
      ]
      tags: [
        type: String
      ]
      extra:
        type: Mixed
      deleteFlag:
        type: Boolean
        default: false

    $super()

  getByTypeAndBelongTo: (type, belongTo) ->
    return @findQ {type: type, belongTo: belongTo, deleteFlag: {$ne: true}}, '-deleteFlag'
