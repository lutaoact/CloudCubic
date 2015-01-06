'use strict'

StatsUtils = _u.getUtils 'stats'

exports.show = (req, res, next) ->
  courseId = req.query.courseId
  classeId = req.query.classeId
  queryUserId = req.query.userId ? req.query.studentId
  user = req.user

  StatsUtils.getQueryUser user, queryUserId, courseId
  .then (person) ->
    StatsUtils.makeKPStatsForUser person, courseId, classeId
  .then (finalStats) ->
    res.send finalStats
  , next
