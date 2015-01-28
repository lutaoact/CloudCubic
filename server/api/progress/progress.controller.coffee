"use strict"

Progress = _u.getModel 'progress'

exports.show = (req, res, next) ->
  user = req.user

  condition =
    userId: user._id
    courseId: req.query.courseId
    classeId: req.query.classeId

  Progress.findOneQ condition
  .then (progressObject) ->
    res.send progressObject?.progress ? []
  , next
