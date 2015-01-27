#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /courses              ->  index
# * POST    /courses              ->  create
# * GET     /courses/:id          ->  show
# * PUT     /courses/:id          ->  update
# * DELETE  /courses/:id          ->  destroy
#

"use strict"

Course = _u.getModel "course"
Classe = _u.getModel "classe"
Forum = _u.getModel 'forum'
CourseUtils = _u.getUtils 'course'

WrapRequest = new (require '../../utils/WrapRequest')(Course)

exports.index = (req, res, next) ->

  conditions = orgId : req.org?._id
  conditions.categoryId = {$in: _.flatten([req.query.categoryIds])} if req.query.categoryIds
  options = limit: req.query.limit, from: req.query.from

  WrapRequest.wrapPageIndex req, res, next, conditions, options


exports.myCourses = (req, res, next) ->
  conditions = orgId: req.org?._id
  conditions.categoryId = {$in: _.flatten([req.query.categoryIds])} if req.query.categoryIds
  conditions.deleteFlag = {$ne: true}

  user = req.user
  userId = user.id
  options = limit: req.query.limit, from: req.query.from

  switch user.role
    when 'admin'
      WrapRequest.wrapPageIndex req, res, next, conditions, options

    when 'student'
      Classe.findQ students: userId
      .then (classes) ->
        courseIds = _.pluck classes, 'courseId'
        conditions._id = $in : courseIds
        WrapRequest.wrapPageIndex req, res, next, conditions, options

    when 'teacher'
      Classe.findQ teachers : userId
      .then (classes) ->
        courseIds = _.pluck classes, 'courseId'
        conditions.$or = [
          _id: $in: courseIds
        ,
          owners: userId
        ]
        WrapRequest.wrapPageIndex req, res, next, conditions, options

    else
      logger.error "Unknown user role: #{user.role}"
      res.send 404


# TODO @lutao
# orderBy 有：开班时间, 开班的价格, 赞的数目(low优先级)
exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapShow req, res, next, conditions


exports.create = (req, res, next) ->
  data = req.body

  delete data._id
  data.owners  = [req.user._id]
  data.orgId   = req.user.orgId
  WrapRequest.wrapCreate req, res, next, data


pickedUpdatedKeys = omit: ['_id', 'orgId', 'deleteFlag']
exports.update = (req, res, next) ->

  CourseUtils.buildWriteConditions req
  .then (conditions) ->
    WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  courseId = req.params.id
  Classe.findQ
    courseId : courseId
  .then (classes) ->
    if classes?.length > 0
      res.send 403, '不能删除有关联班次的课程'
    else
      CourseUtils.buildWriteConditions req
      .then (conditions) ->
        WrapRequest.wrapDestroy req, res, next, conditions
