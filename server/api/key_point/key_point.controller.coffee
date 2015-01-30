"use strict"

KeyPoint = _u.getModel "key_point"
Category = _u.getModel 'category'

exports.index = (req, res, next) ->
  conditions = orgId: req.org._id
  conditions._id = req.query.categoryId if req.query.categoryId

  Category.findQ conditions
  .then (categories) ->
    categoryIds = _.pluck categories, '_id'
    KeyPoint.findQ categoryId: $in: categoryIds
  .then (keyPoints) ->
    res.send keyPoints
  , next

exports.show = (req, res, next) ->
  KeyPoint.findQ
    _id   : req.params.id
    orgId : req.org._id
  .then (keyPoint) ->
    res.send keyPoint
  , next

exports.create = (req, res, next) ->
  delete req.body._id
  KeyPoint.createQ req.body
  .then (keyPoint) ->
    res.send 201, keyPoint
  , next

exports.searchByKeyword = (req, res, next) ->
  name = req.params.name
  regex = new RegExp(_u.escapeRegex(name), 'i')

  KeyPoint.findQ
    name: regex
  .then (keyPoints) ->
    res.send keyPoints
  , next
