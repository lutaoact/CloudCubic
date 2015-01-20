'use strict'

express = require 'express'
controller = require './user.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', auth.hasRole('teacher'), controller.index #?standalone=true
router.get '/me', auth.isAuthenticated(), controller.me
router.get '/check', controller.check #?email=xxxxx
router.get '/matchEmail', auth.hasRole('admin'), controller.matchEmail #?email=xxxxx
router.post '/sendActivationMail', controller.sendActivationMail
router.get '/completeActivation', controller.completeActivation
router.post '/bulk', auth.hasRole('admin'), controller.bulkImport
router.get '/emails/:email', auth.isAuthenticated(), controller.showByEmail
router.post '/multiDelete', auth.hasRole('admin'), controller.multiDelete
router.post '/forgotPassword', controller.forgotPassword
router.post '/resetPassword', controller.resetPassword
router.delete '/:id', auth.hasRole('admin'), controller.destroy
router.put '/:id/password', auth.isAuthenticated(), controller.changePassword
router.put '/:id', auth.isAuthenticated(), controller.update
router.patch '/:id', auth.isAuthenticated(), controller.update
router.get '/:id', auth.isAuthenticated(), controller.show
router.post '/', auth.hasRole('admin'), controller.create

module.exports = router
