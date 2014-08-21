(function() {
  "use strict";
  var auth, controller, express, router;

  express = require("express");

  controller = require("./organization.controller");

  auth = require("../../auth/auth.service");

  router = express.Router();

  router.get("/", controller.index);

  router.get("/me", auth.isAuthenticated(), controller.me);

  router.get("/:id", controller.show);

  router.post("/", auth.hasRole("admin"), controller.create);

  router.put("/:id", auth.hasRole("admin"), controller.update);

  router.patch("/:id", auth.hasRole("admin"), controller.update);

  router["delete"]("/:id", auth.hasRole("admin"), controller.destroy);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map