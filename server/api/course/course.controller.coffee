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
Forum = _u.getModel 'forum'

WrapRequest = new (require '../../utils/WrapRequest')(Course)

exports.index = (req, res, next) ->
  conditions = {orgId: req.org?._id}
  conditions.owners = req.query.owner if req.query.owner
  conditions.categoryId = {$in: _.flatten([req.query.categoryIds])} if req.query.categoryIds
  conditions._id = {$in: _.flatten([req.query.ids])} if req.query.ids

  # unless passed in owner and owner is logged-in user, we need to check isPublished
  unless req.query.owner? and req.user?.id is req.query.owner
    conditions.isPublished = true

  options = limit: req.query.limit, from: req.query.from

  console.log 'options', options
  WrapRequest.wrapPageIndex req, res, next, conditions, options


# TODO @lutao
# orderBy 有：开班时间, 开班的价格, 赞的数目(low优先级)
exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapShow req, res, next, conditions


exports.create = (req, res, next) ->
  data = req.body
  # 先建立forum，然后设置 course 的 forumId
  Forum.createQ {postBy: req.user._id, name: data.name,logo: data.thumbnail, categoryId: data.categoryId?._id||data.categoryId, orgId: req.user.orgId}
  .then (forum) ->
    delete data._id
    data.owners  = [req.user._id]
    data.orgId   = req.user.orgId
    data.forumId = forum._id
    WrapRequest.wrapCreate req, res, next, data
  .catch next
  .done()


pickedUpdatedKeys = omit: ['_id', 'orgId', 'isPublished', 'deleteFlag']
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id, orgId: req.user.orgId}
  conditions.owners = req.user._id if req.user.role is 'teacher'
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id, orgId: req.user.orgId}
  conditions.owners = req.user._id if req.user.role is 'teacher'
  WrapRequest.wrapDestroy req, res, next, conditions


exports.publish = (req, res, next) ->
  conditions = {_id: req.params.id, orgId: req.user.orgId}
  conditions.owners = req.user._id if req.user.role is 'teacher'
  WrapRequest.wrapChangeStatus req, res, next, conditions, {isPublished: true}
