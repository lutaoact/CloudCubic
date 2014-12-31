angular.module 'budweiserApp'

.factory 'Msg', (Restangular, $q)->

  genMessage = (raw)->
    switch raw.type
      when Const.NoticeType.DisTopicComment
        title: '回复了你的帖子：' + raw.data.disTopicId.title
        raw: raw
        link: "forum.topic({forumId:'#{raw.data.forumId._id}',topicId:'#{raw.data.disTopicId._id}'})"
        type: 'message'
      when Const.NoticeType.CourseComment
        title: '回复了你的课程：' + raw.data.courseId.name
        raw: raw
        link: "courseDetail({courseId:'#{raw.data.courseId._id}'})"
        type: 'message'
      when Const.NoticeType.LectureComment
        console.log 'todo'

  instance =
    messages: []
    genMessage: genMessage
    init: ()->
      Restangular.all('notices').getList()
      .then (notices)->
        notices.forEach (notice)->
          instance.messages.splice 0, 0, genMessage(notice)

  return instance

