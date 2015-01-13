'use strict'

Tag = _u.getModel 'tag'
WrapRequest = new (require '../../utils/WrapRequest')(Tag)

exports.index = (req, res, next) ->
  conditions = orgId: req.org?._id
  if req.query.keyword
    regex = new RegExp(_u.escapeRegex(req.query.keyword), 'i')
    conditions.text = regex

  WrapRequest.wrapIndex req, res, next, conditions


pickedKeys = ["text"]
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  data.orgId = req.user.orgId

  WrapRequest.wrapCreate req, res, next, data
