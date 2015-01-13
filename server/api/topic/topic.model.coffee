'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Topic = BaseModel.subclass
  classname: 'Topic'
  populates:
    index: [
      path: 'postBy', select: 'name avatar'
    ]
    show: [
      path: 'postBy', select: 'name avatar'
    ]
    create: [
      path: 'postBy', select: 'name avatar'
    ]

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
      tags: [ String ]
      commentsNum:
        type: Number
        default: 0
      viewersNum:
        type: Number
        default: 0
      likeUsers: [
        type: ObjectId
        ref: 'user'
      ]
      deleteFlag:
        type: Boolean
        default: false

    $super()

  getTopicsNumByForumId: (forumId) ->
    return @countQ forumId: forumId

  getAllByForumId: (forumId) ->
    return @find forumId: forumId
