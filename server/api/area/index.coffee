"use strict"

express = require("express")
controller = require("./area.controller")
router = express.Router()

router.get "/", controller.index

module.exports = router
