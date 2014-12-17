#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /courses              ->  index
# * POST    /courses              ->  create
# * GET     /courses/:id          ->  show
# * PUT     /courses/:id          ->  update
# * DELETE  /courses/:id          ->  destroy
#

"use strict"

_ = require("lodash")
Course = _u.getModel "course"
Lecture = _u.getModel "lecture"
KeyPoint = _u.getModel "key_point"
ObjectId = require("mongoose").Types.ObjectId
CourseUtils = _u.getUtils 'course'
LearnProgress = _u.getModel 'learn_progress'
Forum = _u.getModel 'forum'

WrapRequest = new (require '../../utils/WrapRequest')(Course)

exports.index = (req, res, next) ->
  user = req.user
  logger.info "user.role: #{user.role}"
  (switch user.role
    when 'teacher'
      CourseUtils.getTeacherCourses user._id
    when 'student'
      if req.query.public?
        Course.findQ isPublic:true
      else
        CourseUtils.getStudentCourses user._id
    when 'admin'
      # 管理员可以查看单个老师的课程列表
      if req.query.teacherId
        CourseUtils.getTeacherCourses req.query.teacherId
      else
        CourseUtils.getAdminCourses user.orgId
  ).then (courses) ->
    logger.info "courses.length: #{courses.length}"
    res.send courses
  .catch next
  .done()

exports.publicIndex = (req, res, next) ->
  Course.find orgId: req.org?._id
  .populate 'categoryId'
  .execQ()
  .then (courses) ->
    res.send courses
  .fail next

exports.show = (req, res, next) ->
  courseId = req.params.id
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    course.populateQ 'owners classes'
  .then (course) ->
    res.send course
  .fail next

exports.publicShow = (req, res, next) ->
  courseId = req.params.id
  Course.findById courseId
  .populate 'lectureAssembly', 'name isPublic'
  .execQ()
  .then (course) ->
    res.send course
  .catch next
  .done()


exports.create = (req, res, next) ->
  data = req.body
  delete data._id
  data.owners = [req.user._id]
  data.orgId = req.user.orgId

  # 先建立forum，然后设置course的forumId
  Forum.createQ {postBy: req.user._id, name: data.name}
  .then (forum) ->
    data.forumId = forum._id
    Course.createQ data
  .then (course) ->
    res.json 201, course
  .catch next
  .done()


exports.update = (req, res, next) ->

  # keep old id
  delete req.body._id  if req.body._id

  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    updated = _.extend course, req.body
    updated.markModified 'lectureAssembly'
    updated.markModified 'classes'
    updated.save (err) ->
      next err if err
    course.populateQ 'owners classes'
    .then (course) ->
      res.send course
  .fail next


exports.destroy = (req, res, next) ->
  CourseUtils.getAuthedCourseById req.user, req.params.id
  .then (course) ->
    console.log 'Found course to delete'
    Course.removeQ
      _id : course._id
  .then () ->
    res.send 204
  .fail next
