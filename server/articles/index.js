(function() {
  var express, makeRoute;

  express = require('express');

  makeRoute = function(app) {
    var router;
    router = express.Router();
    router.get('/*', function(req, res) {
      var indexPath;
      console.log(req.query);
      indexPath = app.get('appPath') + '/assets/html/articles/' + req.path;
      return res.sendfile(indexPath, {}, function(err) {
        if (err) {
          return res.render('404');
        }
      });
    });
    return router;
  };

  module.exports = makeRoute;

}).call(this);
