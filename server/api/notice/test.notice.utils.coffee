require '../../common/init'

NoticeUtils = _u.getUtils 'notice'
Topic = _u.getModel 'topic'

#### test code for addLectureNotices ####
userIds = ['111111111111111111111105', '111111111111111111111104', '111111111111111111111103']
lectureId = ['555555555555555555555500']
NoticeUtils.addLectureNotices userIds, lectureId
.then (results) ->
  console.log results
, (err) ->
  console.log err
