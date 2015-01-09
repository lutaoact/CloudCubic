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

  switch user.role
    when 'admin'
      WrapRequest.wrapIndex req, res, next, conditions

    when 'student'
      Classe.findQ students: userId
      .then (classes) ->
        courseIds = _.pluck classes, 'courseId'
        conditions._id = $in : courseIds
        WrapRequest.wrapIndex req, res, next, conditions

    when 'teacher'
      Classe.findQ teachers : userId
      .then (classes) ->
        courseIds = _.pluck classes, 'courseId'
        conditions.$or = [
          _id: $in: courseIds
        ,
          owners: userId
        ]
        options = limit: req.query.limit, from: req.query.from
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
  # 先建立forum，然后设置 course 的 forumId
  forumData =
    postBy: req.user._id
    name: "来自课程-#{data.name}"
    logo: data.thumbnail
    categoryId: data.categoryId?._id ? data.categoryId
    orgId: req.user.orgId

  Forum.createQ forumData
  .then (forum) ->
    delete data._id
    data.owners  = [req.user._id]
    data.orgId   = req.user.orgId
    data.forumId = forum._id
    WrapRequest.wrapCreate req, res, next, data
  .catch next
  .done()



pickedUpdatedKeys = omit: ['_id', 'orgId', 'deleteFlag']
exports.update = (req, res, next) ->

  CourseUtils.buildWriteConditions req
  .then (conditions) ->
    WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  CourseUtils.buildWriteConditions req
  .then (conditions) ->
    WrapRequest.wrapDestroy req, res, next, conditions
