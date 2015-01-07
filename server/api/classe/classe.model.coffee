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
      path: 'teachers', select: 'name avatar'
    ,
      path: 'courseId', select: 'name thumbnail lectureAssembly categoryId'
    ]
    update: [
      path: 'orgId', select: 'name'
    ,
      path: 'teachers', select: 'name avatar'
    ,
      path: 'courseId', select: 'name thumbnail lectureAssembly categoryId'
    ]
    create: [
      path: 'orgId', select: 'name'
    ,
      path: 'teachers', select: 'name avatar'
    ,
      path: 'courseId', select: 'name thumbnail lectureAssembly categoryId'
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
      schedules: [
        start: Date
        end: Date
        until: Date
      ]
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
    @findOneQ {_id: classeId, deleteFlag: {$ne: true}}
    .then (classe) ->
      return classe if classe?
      return Q.reject
        status: 404
        errCode: ErrCode.InvalidClasse
        errMsg: '班级未建立或者已被删除'

  getAllStudents: (classeIds) ->
    unless classeIds.length
      return []

    @findQ _id: $in: classeIds
    .then (classes) ->
      _.reduce classes, (studentIds, classe) ->
        studentIds.concat classe.students
      , []

  buildStudentIds: (classes) ->
    allIds = _.reduce classes, (studentIds, classe) ->
      studentIds.concat classe.students
    , []
    _.uniq allIds, (id) ->
      id.toString()


  getStudentIdsByCourseId: (courseId) ->
    @findQ courseId: courseId
    .then (classes) =>
      @buildStudentIds classes

  getStudentIdsByClasseIds: (classeIds) ->
    unless classeIds?.length
      return Q([])

    @findQ _id: $in: classeIds
    .then (classes) =>
      @buildStudentIds classes


  # return [id & name]
  getAllStudentsInfo: (classeIds) ->
    logger.info classeIds
    @find _id: $in: classeIds
    .populate('students', '_id email name')
    .execQ()
    .then (classes) ->
      _.reduce classes, (studentInfos, classe) ->
        studentInfos.concat classe.students
      , []
