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

# TODO @lutao
# 1.请加上分页 logic (急) limit, from, orderBy: '-created'
# 2.populate 的方式用你之前重构的框架吧
#
# 3.前端现在有两个地方调用 course.index 方法：
#   a.显示我的课程的时候
#   b.显示所有课程的时候
#   这样，publicIIndex 和 index 是不是可以考虑合并一下，用 owner=true 作为一种 condition 区分自己的和别人的
#
# 4.分页过滤，排序的时候，现在的
# filter  有： # owner，category
# orderBy 有：开班时间, 开班的价格, 赞的数目(low优先级)
exports.publicIndex = (req, res, next) ->
  Course.find orgId: req.org?._id
  .populate 'categoryId owners'
  .execQ()
  .then (courses) ->
    res.send courses
  .fail next

# TODO @lutao
# 现在的 course 是公开的，所有人都可以看到，这样的话和下面的 publicShow 重复了，求合体
# index.coffee router 里面的权限可以去掉
exports.show = (req, res, next) ->
  courseId = req.params.id
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    course.populateQ 'owners'
  .then (course) ->
    res.send course
  .fail next

exports.publicShow = (req, res, next) ->
  courseId = req.params.id
  Course.findById courseId
  .populate 'lectureAssembly', 'name isFreeTry'
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
  Forum.createQ {postBy: req.user._id, name: data.name, orgId: req.user.orgId}
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
