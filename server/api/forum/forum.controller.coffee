'use strict'

Forum = _u.getModel 'forum'
Topic = _u.getModel 'topic'
WrapRequest = new (require '../../utils/WrapRequest')(Forum)

exports.index = (req, res, next) ->
  conditions = orgId: req.org?._id
  conditions.name = new RegExp(_u.escapeRegex(req.query.keyword), 'i') if req.query.keyword
  WrapRequest.wrapPageIndex req, res, next, conditions


exports.show = (req, res, next) ->
  conditions = _id: req.params.id, orgId: req.org?._id
  WrapRequest.wrapShow req, res, next, conditions


pickedKeys = ["name", "logo", "info", "categoryId"]
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  data.postBy = req.user._id
  data.orgId = req.user.orgId

  WrapRequest.wrapCreateAndUpdate req, res, next, data


pickedUpdatedKeys = ["name", "logo", "info", "categoryId"]
exports.update = (req, res, next) ->
  conditions = {_id : req.params.id, postBy : req.user._id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


exports.destroy = (req, res, next) ->
  conditions = {_id : req.params.id, postBy : req.user._id}
  WrapRequest.wrapDestroy req, res, next, conditions


exports.topicsNum = (req, res, next) ->
  Topic.getTopicsNumByForumId req.params.id
  .then (num) ->
    res.send {count: num}
  .catch next
  .done()


exports.tagsFreq = (req, res, next) ->
  Topic.getAllByForumId req.params.id
  .then (topics) ->
    tagsFreq = {}
    for topic in topics
      for tag in topic.tags
        tagsFreq[tag] ?= 0
        tagsFreq[tag]++

    result = (for text, freq of tagsFreq
      text: text, freq: freq
    )
    res.send result
  .catch next
  .done()
