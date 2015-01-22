angular.module 'budweiserApp'

.factory 'Msg', (Restangular)->

  genMessage = (raw)->
    msg =
      raw: raw
      type: 'message'

    switch raw.type
      when Const.NoticeType.LikeTopic
        msg.title = '赞了你的帖子：' + raw.data.topicId.title
        msg.link = "forum.topic({forumId:'#{raw.data.forumId._id}',topicId:'#{raw.data.topicId._id}'})"
      when Const.NoticeType.LikeTopicComment
        msg.title = '赞了你的回复：' + raw.data.commentId.content
        msg.link = "forum.topic({forumId:'#{raw.data.forumId._id}',topicId:'#{raw.data.topicId._id}'})"
      when Const.NoticeType.LikeCourseComment
        msg.title = '赞了你的回复：' + raw.data.commentId.content
        if raw.data.classeId?
          msg.link = "course.detail({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}'})"
        else
          msg.link = "teacher.course({courseId:'#{raw.data.courseId._id}'})"
      when Const.NoticeType.LikeLectureComment
        msg.title = '赞了你的回复：' + raw.data.commentId.content
        msg.link = "course.lecture({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}', lectureId:'#{raw.data.lectureId._id}'})"
      when Const.NoticeType.TopicComment
        msg.title = '回复了你的帖子：' + raw.data.topicId.title
        msg.link = "forum.topic({forumId:'#{raw.data.forumId._id}',topicId:'#{raw.data.topicId._id}'})"
      when Const.NoticeType.CourseComment
        msg.title = '回复了你的课程：' + raw.data.courseId.name
        if raw.data.classeId?
          msg.link = "course.detail({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}'})"
        else
          msg.link = "teacher.course({courseId:'#{raw.data.courseId._id}'})"
      when Const.NoticeType.LectureComment
        msg.title = '回复了你的课时：' + raw.data.lectureId.name
        msg.link = "course.lecture({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}', lectureId:'#{raw.data.lectureId._id}'})"

    return msg

  instance =
    unreadMsgCount: 0
    genMessage: genMessage
    init: ()->
      Restangular.all('notices').customGET('unreadCount')
      .then (data)->
        instance.unreadMsgCount = data.unreadCount
        Tinycon.setBubble(instance.unreadMsgCount)
    addMsg: ->
      instance.unreadMsgCount += 1
      Tinycon.setBubble(instance.unreadMsgCount)
    readMsg: ->
      instance.unreadMsgCount -= 1
      Tinycon.setBubble(instance.unreadMsgCount)
    clearMsg: ->
      instance.unreadMsgCount = 0
      Tinycon.setBubble(instance.unreadMsgCount)
    getMsgCount: ->
      instance.unreadMsgCount

  return instance

