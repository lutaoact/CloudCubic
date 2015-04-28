'use strict'

Cart = _u.getModel 'cart'

#populateClasses = (doc)->
#  doc.populateQ 'classes'
#  .then (tmp) ->
#    Q.all _.map tmp.classes, (classe)->
#      classe.populateQ 'courseId'
#  .then () ->
#    return doc

populateClasses = require '../../utils/populateClasses'

exports.show = (req, res, next) ->
  user = req.user
  Cart.findOneQ userId: user._id
  .then (doc) ->
    if doc == null
      return null
    populateClasses doc
  .then (doc) ->
    if doc == null
      res.send []
      return
    res.send doc.classes
  .catch next
  .done()


exports.add = (req, res, next) ->
  user = req.user
  classes = req.body.classes

  Cart.getByUserId user._id
  .then (doc) ->
    if doc
      doc.classes.addToSet.apply doc.classes, classes
      doc.saveQ()
      .then (result) ->
        return result[0]
    else
      data = userId: user._id, classes: classes
      Cart.createQ data
  .then (doc) ->
    populateClasses doc
  .then (doc)->
    res.send doc.classes
  .catch next
  .done()


exports.remove = (req, res, next) ->
  user = req.user
  classes = req.body.classes

  Cart.getByUserId user._id
  .then (doc) ->
    doc.classes.pull.apply doc.classes, classes
    do doc.saveQ
  .then (result) ->
    populateClasses result[0]
  .then (doc)->
    res.send doc.classes
  .catch next
  .done()
