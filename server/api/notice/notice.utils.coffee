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

    console.log 'To create notice ', notice
    Notice.createQ notice
    .then (noticeDoc) =>
      for option in Notice.populates?.create
        noticeDoc = noticeDoc.populate option
      noticeDoc.populateQ()

  addLectureNotices: (userIds, lectureId) ->
    data = {lectureId : lectureId}
    @addNotice(userId, null, Const.NoticeType.Lecture, data) for userId in userIds
      
exports.NoticeUtils = NoticeUtils
