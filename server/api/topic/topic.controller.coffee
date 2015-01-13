'use strict'

Topic = _u.getModel 'topic'
CourseUtils = _u.getUtils 'course'
DisUtils = _u.getUtils 'dis'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'
Forum = _u.getModel 'forum'

WrapRequest = new (require '../../utils/WrapRequest')(Topic)

exports.index = (req, res, next) ->
  conditions = forumId: req.query.forumId
  options = from: ~~req.query.from #from参数转为整数

# 三行的版本看起来更刁，但由于耗费行数太多，不是我的风格，遂被放弃
# 最后改用一行的版本，三行版本留在这里供大家参考
#  params = Array::slice.call arguments, 0
#  params.push conditions, options
#  WrapRequest.wrapPageIndex.apply WrapRequest, params
  WrapRequest.wrapPageIndex req, res, next, conditions, options


# 每看一次，viewersNum增加1
exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapShow req, res, next, conditions, {$inc: {viewersNum: 1}}


pickedKeys = ["forumId", "title", "content", "tags"]
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  data.postBy = req.user._id
  data.forumId ?= req.query.forumId
  data.orgId = req.org?._id

  updateConds = {_id: forumId}
  update = {$inc: {postsCount: 1}}

  WrapRequest.wrapCreateAndUpdate req, res, next, data, Forum, updateConds, update


exports.update = (req, res, next) ->
  updateBody = {}
  updateBody.title     = req.body.title     if req.body.title?
  updateBody.content   = req.body.content   if req.body.content?
  updateBody.lectureId = req.body.lectureId if req.body.lectureId?

  Topic.findOneQ
    _id : req.params.id
    postBy : req.user.id
  .then (topic) ->
    updated = _.extend topic, updateBody
    do updated.saveQ
  .then (result) ->
    logger.info result
    newValue = result[0]
    newValue.populateQ 'postBy', '_id name avatar'
  .then (newTopic) ->
    res.send newTopic
  , next

exports.destroy = (req, res, next) ->
  conditions =
    _id: req.params.id
    postBy : req.user.id

  WrapRequest.wrapDestroy req, res, next, conditions


exports.like = (req, res, next) ->
  console.log 'receive like from ', req.user.id
  WrapRequest.wrapLike req, res, next
