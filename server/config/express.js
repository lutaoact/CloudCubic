/**
 * Express configuration
 */

'use strict';

var express = require('express');
var favicon = require('static-favicon');
var morgan = require('morgan');
var compression = require('compression');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var cookieParser = require('cookie-parser');
var errorHandler = require('errorhandler');
var path = require('path');
var config = require('./environment');
var passport = require('passport');

module.exports = function(app) {
  var env = app.get('env');
  console.log("Env is " + env);

  app.set('views', config.root + '/server/views');
  app.engine('html', require('ejs').renderFile);
  app.set('view engine', 'html');
  app.use(compression());
  app.use(bodyParser());
  app.use(methodOverride());
  app.use(cookieParser());
  app.use(passport.initialize());

  if ('production' === env || 'online_test' === env) {
    var allowCrossDomain = function(req, res, next) {
      if(req.host=='statics.cloud3edu.cn') {
        res.header('Access-Control-Allow-Origin', '*');
        res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTION,PATCH');
        res.header('Access-Control-Allow-Headers', 'Content-Type,Authorization');
      }
      next();
    };
    app.use(allowCrossDomain);
    app.use(favicon(path.join(config.root, 'public', 'favicon.ico')));
    app.use(express.static(path.join(config.root, 'public'), {index: 'index'}));
    app.set('appPath', config.root + '/public');
    app.use(morgan('dev'));
  }

  if ('development' === env || 'test' === env) {
    //TODO check production
    //CORS middleware
    var allowCrossDomain = function(req, res, next) {
      res.header('Access-Control-Allow-Origin', '*');
      res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTION,PATCH');
      res.header('Access-Control-Allow-Headers', 'Content-Type,Authorization');

      next();
    };
    app.use(allowCrossDomain);
    app.use(require('connect-livereload')());
    app.use(express.static(path.join(config.root, '.tmp'), {index: 'index'}));
    app.use(express.static(path.join(config.root, 'client'), {index: 'index'}));
    app.set('appPath', 'client');
    app.use(morgan('dev'));
    app.use(errorHandler()); // Error handler - has to be last
  }
};
