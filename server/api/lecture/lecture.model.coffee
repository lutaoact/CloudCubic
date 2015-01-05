"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Lecture = BaseModel.subclass
  classname: 'Lecture'
  populates:
    show: [
      path: 'keyPoints.kp'
    ,
      path: 'homeworks'
    ,
      path: 'quizzes'
    ]
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      thumbnail: String
      info: String
      desc: String
      files: [
        fileName: String
        fileContent: [
          thumb: String
          raw: String
        ]
        fileWidth: Number
        fileHeight: Number
      ]
      media: String
      encodedMedia: String
      externalMedia: String
      keyPoints: [
        kp :
          type: Schema.Types.ObjectId
          ref : "key_point"
        timestamp: Number
      ]
      quizzes: [
        type: Schema.Types.ObjectId
        ref: "question"
      ]
      homeworks: [
        type: Schema.Types.ObjectId
        ref: "question"
      ]
      courseId:
        type: ObjectId
        ref: 'course'
      isFreeTry:
        type: Boolean
        default: false
      commentsNum:
        type: Number
        default: 0

    $super()
