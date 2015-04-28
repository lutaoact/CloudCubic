populateClasses = (doc)->
  doc.populateQ 'classes'
  .then (tmp) ->
    Q.all _.map tmp.classes, (classe)->
      classe.populateQ 'courseId'
  .then () ->
    return doc

module.exports = populateClasses