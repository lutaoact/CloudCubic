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
#  params.push.call params, conditions, options
#  WrapRequest.wrapPageIndex.apply WrapRequest, params
  WrapRequest.wrapPageIndex req, res, next, conditions, options


exports.show = (req, res, next) ->
  DisTopic.findByIdAndUpdate req.params.id, {$addToSet: {viewers: req.user._id}}
  .populate 'postBy', '_id name avatar'
  .execQ()
  .then (disTopic) ->
    res.send disTopic
  , next

exports.create = (req, res, next) ->
  user     = req.user
  courseId = req.query.courseId
  body     = req.body
  delete body._id

  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    #don't post voteUpUsers field, it's illegal, I will override it
    #新记录的voteUpUsers值应该为空数组，所以强制赋值
    body.voteUpUsers = []
    body.postBy      = user._id
    body.courseId    = courseId

    DisTopic.createQ body
  .then (disTopic) ->
    disTopic.populateQ 'postBy', '_id name avatar'
  .then (disTopic) ->
    logger.info disTopic
    res.send 201, disTopic
  , next

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
