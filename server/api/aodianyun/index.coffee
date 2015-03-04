"use strict"

express = require("express")
auth = require("../../auth/auth.service")
router = express.Router()
request = require 'request'

AodianyunUtils = _u.getUtils 'aodianyun'

router.post "/openThenStart", auth.isAuthenticated(), (req, res, next) ->
  appid   = 'orgId_' + req.org._id
  appname = req.org.uniqueName
  # appname 长度在20字符以内
  AodianyunUtils.openThenStart appid, appname.substr 0, 20
  .then () ->
    res.send appid: appid
  .catch next
  .done()

router.post "/close", auth.isAuthenticated(), (req, res, next) ->
  appid = 'orgId_' + req.org._id
  AodianyunUtils.closeAppQ appid
  .then () ->
    res.send appid: appid
  .catch next
  .done()

module.exports = router
