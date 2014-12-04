express = require 'express'

makeRoute = (app)->
  router = express.Router()

  router.get '/*', (req, res) ->
    console.log req.url
    indexPath = app.get('appPath') + '/assets/html/articles/' + req.url
    res.sendfile indexPath

  router

module.exports = makeRoute
