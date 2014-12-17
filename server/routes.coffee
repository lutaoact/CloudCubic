# Main application routes

'use strict'

errors = require './components/errors'
fs = require 'fs'
byline = require 'byline'
jwt = require 'jsonwebtoken'
config = require './config/environment'
Organization = _u.getModel "organization"

errorHandler = (err, req, res, next) ->
  logger.error err
  result =
    name: err?.name
    message: err?.message
    errors: err?.errors
  res.json err.status || 500, result

orgGetter = (req, res, next) ->
  logger.info "req.method: #{req.method}, req.originalUrl: #{req.originalUrl}"

  host = req.headers.host
  defaultHost = config.host.replace /^.*:\/\//, ''

  Q(
    if host isnt defaultHost
      # 匹配出二级域名
      regexp = new RegExp('^(.*)\\.\\b' + defaultHost + '$')
      logger.info "host match regexp: ", regexp
      matches = host.match regexp
      logger.info 'current host: ', host
      logger.info "host.match result:", matches

      if matches?.length is 2
        Organization.findBy matches[1]
      else
        Organization.findByCustomDomain host
  ).then (org) ->
    if org? or host is defaultHost
      req.org = org
      next()
    else
      res.render '404'
  .catch(next)
  .done()

module.exports = (app) ->

  # Insert routes below
  app.use orgGetter
  app.use '/api/users', require './api/user'
  app.use '/api/courses', require './api/course'
  app.use '/api/categories', require './api/category'
  app.use '/api/classes', require './api/classe'
  app.use '/api/organizations', require './api/organization'
  app.use '/api/qiniu', require './api/qiniu'
  app.use '/api/assets', require './api/asset'
  app.use '/api/slides', require './api/slide'
  app.use '/api/lectures', require './api/lecture'
  app.use '/api/dis_topics', require './api/dis_topic'
  app.use '/api/dis_replies', require './api/dis_reply'
  app.use '/api/questions', require './api/question'
  app.use '/api/class_progresses', require './api/class_progress'
  app.use '/api/key_points', require './api/key_point'
  app.use '/api/homework_answers', require './api/homework_answer'
  app.use '/api/homework_stats', require './api/homework_stats'
  app.use '/api/quiz_answers', require './api/quiz_answer'
  app.use '/api/quiz_stats', require './api/quiz_stats'
  app.use '/api/lecture_stats', require './api/lecture_stats'
  app.use '/api/keypoint_stats', require './api/keypoint_stats'
  app.use '/api/activities', require './api/activity'
  app.use '/api/progresses', require './api/progress'
  app.use '/api/schools', require './api/school'
  app.use '/api/schedules', require './api/schedule'
  app.use '/api/notices', require './api/notice'
  app.use '/api/offline_works', require './api/offline_work'
  app.use '/api/demo', require './api/demo'
  app.use '/auth', require './auth'
  app.use '/api/bind', require './api/bind'
  app.use '/api/register', require './api/register'
  app.use '/api/devices', require './api/device'
  app.use '/api/superuser', require './api/superuser'
  app.use '/api/broadcasts', require './api/broadcast'
  app.use '/api/azure_encode_tasks', require './api/azure_encode_task'
  app.use '/api/user_lecture_notes', require './api/user_lecture_note'
  app.use '/api/areas', require './api/area'
  app.use '/api/admins', require './api/admin'
  app.use '/api/payments', require './api/payment'
  app.use errorHandler

  # All undefined asset or api routes should return a 404
  app.route '/:url(api|auth|components|app|bower_components|assets)/*'
  .get errors[404]

  app.use '/articles', require('./articles')(app)

  app.route '/common/Const.js'
  .get (req, res) ->
    res.sendfile __dirname + '/common/Const.js'

  # All other routes should redirect to the index.html
  app.route '/*'
  .get (req, res) ->
    # if there is no cookie token, return index.html immediately
    indexPath = app.get('appPath') + '/index.html'
    locals =
      webview: "#{req.query.webview?}"
      initUser: "null"
      initNotify: "#{JSON.stringify(req.query.message)}"
      org: "#{JSON.stringify(req.org)}"

    token = (req.cookies.token ? req.query.access_token)?.replace /"/g, ''

    if !token?
      res.send(_u.render indexPath, locals)
    else
      logger.info 'refreshing, token:'
      logger.info token
      # remove double quote
      jwt.verify token, config.secrets.session, null, (err, user) ->
        logger.info "after verity token, we get user:"
        logger.info user

        unless err?
          res.cookie('token', JSON.stringify(token))
          locals.initUser = JSON.stringify  _id: user._id, role: user.role

        res.send(_u.render indexPath, locals)
