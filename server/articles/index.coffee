express = require 'express'

makeRoute = (app)->
  router = express.Router()

  router.get '/*', (req, res) ->
    console.log req.query
    indexPath = app.get('appPath') + '/assets/html/articles/' + req.path
    res.sendfile indexPath, {}, (err)->
      if err
        res.render('404')

  router

module.exports = makeRoute
