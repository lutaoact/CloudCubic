'use strict'

express = require 'express'
controller = require './asset.controller'
auth = require '../../auth/auth.service'

router = express.Router()

# image request will not send Authorization in header, thus, auth.isAuthenticated() fails. Consider using cookie.
router.get  '/images/:assetType/*', auth.isAuthenticated(false), controller.getImages
router.get  '/videos/:assetType/*', auth.isAuthenticated(false), controller.getVideos
router.get  '/slides/:assetType/*', auth.isAuthenticated(false), controller.getSlides
router.get  '/upload/images', auth.isAuthenticated(), controller.uploadImage
router.get  '/upload/videos', auth.isAuthenticated(), controller.uploadVideo
router.get  '/upload/slides', auth.isAuthenticated(), controller.uploadSlide

module.exports = router
