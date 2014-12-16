"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Course = BaseModel.subclass
  classname: 'Course'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      orgId:
        type: ObjectId
        ref: 'organization'
        required: true
      categoryId:
        type: ObjectId
        ref: "category"
        required: true
      thumbnail: String
      info: String
      lectureAssembly: [
        type: ObjectId
        ref: "lecture"
      ]
      owners: [
        type: ObjectId
        ref: "user"
      ]
      public:
        type: Boolean
        default: false
      deleteFlag:
        type: Boolean
        default: false

    $super()
