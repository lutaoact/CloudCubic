"use strict"

express = require("express")
controller = require("./key_point.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index #[categoryId=xxxxx]可选
router.get "/:id", controller.show
router.post "/", auth.hasRole("teacher"), controller.create
#router.delete "/:id", auth.hasRole("teacher"), controller.destroy

router.get "/search/:name", auth.hasRole("teacher"), controller.searchByKeyword

module.exports = router
