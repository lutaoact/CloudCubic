express = require 'express'

makeRoute = (app)->
  router = express.Router()

  router.get '/*', (req, res) ->
    console.log req.url
    indexPath = app.get('appPath') + '/assets/html/articles/' + req.url
    res.sendfile indexPath, {}, (err)->
      if err
        res.render('404')

  router

module.exports = makeRoute
