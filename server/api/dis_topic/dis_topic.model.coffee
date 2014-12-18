'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.DisTopic = BaseModel.subclass
  classname: 'DisTopic'
  populates:
    index:
      postBy: 'name avatar'
    show:
      postBy: 'name avatar'
    create:
      postBy: 'name avatar'

  initialize: ($super) ->
    @schema = new Schema
      postBy:
        type: ObjectId
        ref: 'user'
        required: true
      forumId:
        type: ObjectId
        ref: 'forum'
        required: true
      title:
        type: String
        required: true
      content:
        type: String
        required: true
      metadata: Schema.Types.Mixed
#        images: [
#          type: String
#        ]
#        tags: [
#          type: String
#        ]
      repliesNum:
        type: Number
        required: true
        default: 0
      viewers: [
        type: ObjectId
        ref: 'user'
      ]
      voteUpUsers: [
        type: ObjectId
        ref: 'user'
      ]

    $super()
