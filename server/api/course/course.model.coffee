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
      path: 'owners', select: 'name avatar title'
    ]
    create: [
      path: 'categoryId', select: 'name'
    ,
      path: 'owners', select: 'name avatar title info'
    ,
      path: 'lectureAssembly', select: 'name isFreeTry info'
    ]
    update: [
      path: 'categoryId', select: 'name'
    ,
      path: 'owners', select: 'name avatar title info'
    ,
      path: 'lectureAssembly', select: 'name isFreeTry info'
    ]
    show: [
      path: 'categoryId', select: 'name'
    ,
      path: 'owners', select: 'name avatar title info'
    ,
      path: 'lectureAssembly', select: 'name isFreeTry info'
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
      deleteFlag:
        type: Boolean
        default: false
      commentsNum:
        type: Number
        default: 0

    $super()

  getById: (courseId) ->
    @findByIdQ courseId
    .then (course) ->
      return course if course?
      return Q.reject
        status: 404
        errCode: ErrCode.NoCourse
        errMsg: '没有找到该课程'

      course

  getByLectureId: (lectureId) ->
    @findOneQ lectureAssembly: lectureId
    .then (course) ->
      return course if course?
      return Q.reject
        status: 404
        errCode: ErrCode.NoCourse
        errMsg: '没有找到该课程'
