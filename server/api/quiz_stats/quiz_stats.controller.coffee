'use strict'

StatsUtils  = _u.getUtils 'stats'
LectureUtils = _u.getUtils 'lecture'
User        = _u.getModel 'user'

exports.show = (req, res, next) ->
  courseId = req.query.courseId
  user = req.user

  (if user.role is 'teacher' and req.query.studentId?
    User.findByIdQ req.query.studentId
  else
    Q(user)
  ).then (person) ->
    StatsUtils.makeQuizStatsPromiseForUser person, courseId
  .then (finalStats) ->
    res.send finalStats
  , next

exports.realTimeView = (req, res, next) ->
  lectureId  = req.query.lectureId
  questionId = req.query.questionId
  user = req.user

  LectureUtils.getAuthedLectureById user, lectureId
  .then (lecture) ->
    StatsUtils.getQuizStats lectureId, questionId
  .then (result) ->
    res.send result
  , next
