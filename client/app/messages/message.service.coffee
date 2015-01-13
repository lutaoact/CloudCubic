angular.module 'budweiserApp'

.factory 'Msg', (Restangular)->

  genMessage = (raw)->
    switch raw.type
      when Const.NoticeType.LikeTopic
        title: '赞了你的帖子：' + raw.data.topicId.title
        raw: raw
        link: "forum.topic({forumId:'#{raw.data.forumId._id}',topicId:'#{raw.data.topicId._id}'})"
        type: 'message'
      when Const.NoticeType.LikeTopicComment
        title: '赞了你的回复：' + raw.data.commentId.content
        raw: raw
        link: "forum.topic({forumId:'#{raw.data.forumId._id}',topicId:'#{raw.data.topicId._id}'})"
        type: 'message'
      when Const.NoticeType.LikeCourseComment
        title: '赞了你的回复：' + raw.data.commentId.content
        raw: raw
        link: "course.detail({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}'})"
        type: 'message'
      when Const.NoticeType.LikeLectureComment
        title: '赞了你的回复：' + raw.data.commentId.content
        raw: raw
        link: "course.lecture({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}', lectureId:'#{raw.data.lectureId._id}'})"
        type: 'message'
      when Const.NoticeType.TopicComment
        title: '回复了你的帖子：' + raw.data.topicId.title
        raw: raw
        link: "forum.topic({forumId:'#{raw.data.forumId._id}',topicId:'#{raw.data.topicId._id}'})"
        type: 'message'
      when Const.NoticeType.CourseComment
        title: '回复了你的课程：' + raw.data.courseId.name
        raw: raw
        link: "course.detail({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}'})"
        type: 'message'
      when Const.NoticeType.LectureComment
        title: '回复了你的课时：' + raw.data.lectureId.name
        raw: raw
        link: "course.lecture({courseId:'#{raw.data.courseId._id}', classeId:'#{raw.data.classeId._id}', lectureId:'#{raw.data.lectureId._id}'})"
        type: 'message'

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

