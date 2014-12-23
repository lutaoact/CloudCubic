"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Course = BaseModel.subclass
  classname: 'Course'
  populates:
    index: [
      path: 'categoryId', select: 'name'
    ,
      path: 'owners', select: 'name avatar'
    ]
    create: [
      path: 'categoryId', select: 'name'
    ,
      path: 'owners', select: 'name avatar'
    ]
    show: [
      path: 'categoryId', select: 'name'
    ,
      path: 'owners', select: 'name avatar'
    ,
      path: 'lectureAssembly'
    ]
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
      forumId:
        type: ObjectId
        ref: "forum"
        required: true
      thumbnail: String
      info: String
      description: String
      lectureAssembly: [
        type: ObjectId
        ref: "lecture"
      ]
      owners: [
        type: ObjectId
        ref: "user"
      ]
      isPublished:
        type: Boolean
        default: false
      deleteFlag:
        type: Boolean
        default: false

    $super()

  getById: (courseId) ->
    return @findByIdQ courseId
      .then (course) ->
        unless course
          return Q.reject
            status: 404
            errCode: ErrCode.NoCourse
            errMsg: '没有找到该课程'

        return course
