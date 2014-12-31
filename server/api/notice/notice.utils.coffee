Notice = _u.getModel 'notice'
DisTopic = _u.getModel 'dis_topic'


class NoticeUtils
  addNotice: (userId, fromWhom, type, data) ->
    notice =
      userId: userId
      fromWhom: fromWhom
      type: type
      data: data
      status: 0

    Notice.createQ notice
    .then (noticeDoc) =>
      for option in Notice.populates?.create
        noticeDoc = noticeDoc.populate option
      noticeDoc.populateQ()

  #fromWhom给userId的disTopicId评论了
  addTopicCommentNotice: (userId, fromWhom, disReplyId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicComment, disReplyId

  #fromWhom给userId的disTopicId点赞了
  addTopicVoteUpNotice: (userId, fromWhom, disTopicId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicVoteUp, disTopicId

  #fromWhom给userId的disReplyId点赞了
  addTopicCommentVoteUpNotice: (userId, fromWhom, disReplyId) ->
    return @addNotice userId, fromWhom, Const.NoticeType.TopicCommentVoteUp, disReplyId

  #userId，有新的lecture发布了哦，赶紧去看吧
  buildLectureNotices: (userIds, lectureId) ->
    return (for userId in userIds
      userId: userId
      type: Const.NoticeType.Lecture
      status: 0
      data:
        lecture: lectureId
    )

  addLectureNotices: (userIds, lectureId) ->
    datas = @buildLectureNotices userIds, lectureId

    Notice.createQ datas

exports.NoticeUtils = NoticeUtils
