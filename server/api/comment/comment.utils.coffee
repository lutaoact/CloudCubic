BaseUtils = require('../../common/BaseUtils')
Course = _u.getModel 'course'
Topic = _u.getModel 'topic'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'


getMoreData = (data) ->
  switch data.type
    when Const.CommentType.Topic
      Topic.findByIdQ data.belongTo
      .then (topic)->
        data.topic = topic

    when Const.CommentType.Course
      Course.findByIdQ data.belongTo
      .then (course)->
        data.course = course

    when Const.CommentType.Lecture
      Course.getByLectureId data.belongTo
      .then (course)->
        data.course = course


# get all users this comment is targeted to.
# For discuss topic, it will be the author of topic
# For course, it will be all course owners
# For lecture, it will be lecture's course owners
# For Teacher, it will be teacher himself
getTargetUsers = (data) ->
  switch data.type
    when Const.CommentType.Topic
      if data.topic.postBy.equals data.postBy
        data.targetUsers = []
      else
        data.targetUsers = [data.topic.postBy]

    when Const.CommentType.Course, Const.CommentType.Lecture
      data.targetUsers = data.course.owners
      _.remove data.targetUsers, (owner) -> owner.equals data.postBy


addCommentNotice = (targetUser, data)->
  switch data.type
    when Const.CommentType.Topic
      noticeData =
        topicId: data.topic._id
        forumId: data.topic.forumId
      NoticeUtils.addNotice targetUser, data.postBy, Const.NoticeType.TopicComment, noticeData

    when Const.CommentType.Course
      noticeData =
        courseId: data.course._id
        classeId: data.extra?.classeId
      NoticeUtils.addNotice targetUser, data.postBy, Const.NoticeType.CourseComment, noticeData

    when Const.CommentType.Lecture
      noticeData =
        lectureId: data.belongTo
        courseId: data.course._id
        classeId: data.extra?.classeId
      NoticeUtils.addNotice targetUser, data.postBy, Const.NoticeType.LectureComment, noticeData


class CommentUtils extends BaseUtils
  getCommentRefByType: (type) ->
    return _u.getModel Const.CommentModelRef[type]

  sendCommentNotices : (data)->
    getMoreData(data)
    .then ()->
      getTargetUsers data
#      console.log data.targetUsers
      notices = _.map data.targetUsers, (targetUser) ->
        addCommentNotice(
          targetUser
          data
        )
      Q.all notices
    .then (notices) ->
#      console.log 'notices are' , notices
      SocketUtils.sendNotices notices
      # TODO: for mobile app
      #DeviceUtils.pushToUser notice for notice in notices
          
      
exports.Instance = new CommentUtils()
exports.Class = CommentUtils
exports.CommentUtils = CommentUtils
