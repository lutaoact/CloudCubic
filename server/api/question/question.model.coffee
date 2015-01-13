"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Question = BaseModel.subclass
  classname: 'Question'
  populates:
    index: [
      path: 'keyPoints', select: 'name'
    ]
    ceate: [
      path: 'keyPoints', select: 'name'
    ]
    show: [
      path: 'keyPoints', select: 'name'
    ]
    update: [
      path: 'keyPoints', select: 'name'
    ]
  initialize: ($super) ->
    @schema = new Schema
      orgId:
        type: Schema.Types.ObjectId
        ref: "organization"
      categoryId:
        type: Schema.Types.ObjectId
        ref: "category"
      level:
        type: Number
        default: 50
      keyPoints : [
        type: Schema.Types.ObjectId
        ref: "key_point"
      ]
      body: String #题干
      type: #1:choice 2:fill blank
        type: Number
        required: true
        default: 1
      choices: [
        text: String #rich text
        correct: Boolean
      ]
      solution: String #填空题的答案
      detailSolution:
        type: String #详解
      deleteFlag:
        type: Boolean
        default: false

    $super()
