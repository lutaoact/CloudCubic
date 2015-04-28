'use strict'

express = require 'express'
controller = require './quiz_stats.controller'
auth = require '../../auth/auth.service'

router = express.Router()

#?courseId=xxxx[&studentId=xxxx&classeId=xxxx] studentId用来查看指定学生 classeId用来查看指定班级
router.get '/', auth.isAuthenticated(), controller.show
router.get '/real_time', auth.hasRole('teacher'), controller.realTimeView

module.exports = router
