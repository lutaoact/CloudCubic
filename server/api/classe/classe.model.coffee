"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Classe = BaseModel.subclass
  classname: 'Classe'
  populates:
    index: [
      path: 'orgId', select: 'name'
    ,
      path: 'teachers', select: 'name'
    ,
      path: 'courseId', select: 'name'
    ]
    update: [
      path: 'orgId', select: 'name'
    ,
      path: 'teachers', select: 'name'
    ,
      path: 'courseId', select: 'name'
    ]
    create: [
      path: 'orgId', select: 'name'
    ,
      path: 'courseId', select: 'name'
    ]

  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      address: String
      orgId:
        type: ObjectId
        ref: 'organization'
        required: true
      courseId:
        type: ObjectId
        ref: 'course'
      # 报名时间段
      enrollment:
        from: Date
        to: Date
      # 上课时间段
      duration:
        from: Date
        to: Date
      students: [
        type: ObjectId
        ref: 'user'
      ]
      teachers: [
        type: ObjectId
        ref: 'user'
      ]
      schedule:
        start: Date
        end: Date
        until: Date
      price:
        type: Number
        required: true
        default: 0
      isOpen:
        type: Boolean
        default: true
      deleteFlag:
        type: Boolean
        default: false

    @schema
    .path 'name'
    .validate (name, respond) ->
      self = this
      this.constructor.findOne
        name : name
        orgId: self.orgId
      , (err, data) ->
        throw err if err
        notTaken = !data or data.id == self.id
        respond notTaken
    , '该班级名称已被占用，请选择其他名称'

    $super()

  getOneById: (classeId) ->
    return @findOneQ {_id: classeId, deleteFlag: {$ne: true}}
    .then (classe) ->
      unless classe
        return Q.reject
          status: 404
          errCode: ErrCode.InvalidClasse
          errMsg: '班级未建立或者已被删除'

      return classe

  getAllStudents: (classeIds) ->
    @findQ _id: $in: classeIds
    .then (classes) ->
      return _.reduce classes, (studentIds, classe) ->
        return studentIds.concat classe.students
      , []

  buildStudentIds: (classes) ->
    allIds = _.reduce classes, (studentIds, classe) ->
      return studentIds.concat classe.students
    , []
    return _.uniq allIds, (id) ->
      return id.toString()


  getStudentIdsByCourseId: (courseId) ->
    return @findQ courseId: courseId
      .then (classes) =>
        return @buildStudentIds classes

  getStudentIdsByClasseIds: (classeIds) ->
    return @findQ _id: $in: classeIds
      .then (classes) =>
        return @buildStudentIds classes

  # return [id & name]
  getAllStudentsInfo: (classeIds) ->
    logger.info classeIds
    @find _id: $in: classeIds
    .populate('students', '_id email name')
    .execQ()
    .then (classes) ->
      return _.reduce classes, (studentInfos, classe) ->
        return studentInfos.concat classe.students
      , []
