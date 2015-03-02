"use strict"

Progress = _u.getModel 'progress'

exports.index = (req, res, next) ->
  user = req.user

  condition =
    userId: req.query.userId or user._id
  condition.courseId = req.query.courseId if req.query.courseId
  condition.classeId = req.query.classeId if req.query.classeId

  Progress.findOneQ condition
  .then (progressObject) ->
    res.send progressObject?.progress ? []
  , next
