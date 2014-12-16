"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Course = BaseModel.subclass
  classname: 'Course'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      orgId:
        type: Schema.Types.ObjectId
        ref: 'organization'
        required: true
      categoryId:
        type: Schema.Types.ObjectId
        ref: "category"
        required: true
      thumbnail: String
      info: String
      lectureAssembly: [
        type: Schema.Types.ObjectId
        ref: "lecture"
      ]
      owners: [
        type: Schema.Types.ObjectId
        ref: "user"
      ]
      public:
        type: Boolean
        default: false
      deleteFlag:
        type: Boolean
        default: false

    $super()
