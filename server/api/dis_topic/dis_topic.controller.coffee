'use strict'

DisTopic = _u.getModel 'dis_topic'
CourseUtils = _u.getUtils 'course'
DisUtils = _u.getUtils 'dis'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'

WrapRequest = new (require '../../utils/WrapRequest')(DisTopic)

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

exports.create = (req, res, next) ->
  user     = req.user
  forumId  = req.query.forumId
  body     = req.body
  delete body._id

  body.likeUsers = []
  body.postBy      = user._id
  body.forumId     = forumId

  DisTopic.createQ body
  .then (disTopic) ->
    disTopic.populateQ 'postBy', '_id name avatar'
  .then (disTopic) ->
    logger.info disTopic
    res.send 201, disTopic
  .catch next
  .done()

exports.update = (req, res, next) ->
  updateBody = {}
  updateBody.title     = req.body.title     if req.body.title?
  updateBody.content   = req.body.content   if req.body.content?
  updateBody.lectureId = req.body.lectureId if req.body.lectureId?

  DisTopic.findOneQ
    _id : req.params.id
    postBy : req.user.id
  .then (disTopic) ->
    updated = _.extend disTopic, updateBody
    do updated.saveQ
  .then (result) ->
    logger.info result
    newValue = result[0]
    newValue.populateQ 'postBy', '_id name avatar'
  .then (newDisTopic) ->
    res.send newDisTopic
  , next

exports.destroy = (req, res, next) ->
  DisTopic.removeQ
    _id: req.params.id
    postBy : req.user.id
  .then () ->
    res.send 204
  , next

exports.vote = (req, res, next) ->
  disTopicId = req.params.id
  userId = req.user._id

  DisUtils.vote DisTopic, disTopicId, userId
  .then (dis) ->
    res.send dis
  , next
