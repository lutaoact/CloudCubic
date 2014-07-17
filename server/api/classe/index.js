(function() {
  'use strict';
  var controller, express, router, auth;

  express = require('express');

  controller = require('./classe.controller');

  auth = require('../../auth/auth.service');

  router = express.Router();

  router.get('/', auth.isAuthenticated(), controller.index);

  router.get('/:id', auth.isAuthenticated(), controller.show);

  router.post('/', auth.hasRole('admin'), controller.create);

  router.put('/:id', auth.hasRole('admin'), controller.update);

  router.patch('/:id', auth.hasRole('admin'), controller.update);

  // router["delete"]('/:id', auth.hasRole('admin'), controller.destroy);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map
