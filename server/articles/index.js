(function() {
  var express, makeRoute;

  express = require('express');

  makeRoute = function(app) {
    var router;
    router = express.Router();
    router.get('/*', function(req, res) {
      var indexPath;
      console.log(req.url);
      indexPath = app.get('appPath') + '/assets/html/articles/' + req.url;
      return res.sendfile(indexPath);
    });
    return router;
  };

  module.exports = makeRoute;

}).call(this);
