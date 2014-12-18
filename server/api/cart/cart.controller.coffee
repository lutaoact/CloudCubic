'use strict'

Cart = _u.getModel 'cart'

exports.show = (req, res, next) ->
  user = req.user

  Cart.findOneQ userId: user._id
  .then (doc) ->
    res.send doc
  .catch next
  .done()


exports.add = (req, res, next) ->
  user = req.user
  classeIds = req.body.classeIds

  Cart.getByUserId user._id
  .then (doc) ->
    if doc
      doc.classes.addToSet.apply doc.classes, classeIds
      doc.saveQ()
      .then (result) ->
        return result[0]
    else
      data = userId: user._id, classes: classeIds
      Cart.createQ data
  .then (doc) ->
    res.send doc
  .catch next
  .done()


exports.remove = (req, res, next) ->
  user = req.user
  classeIds = req.body.classeIds

  Cart.getByUserId user._id
  .then (doc) ->
    doc.classes.pull.apply doc.classes, classeIds
    do doc.saveQ
  .then (result) ->
    res.send result[0]
  .catch next
  .done()
