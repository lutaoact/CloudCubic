require '../common/init'
passport = require 'passport'

User = _u.getModel 'user'
WeiboStrategy = require('passport-weibo').Strategy
QQStrategy = require('passport-qq').Strategy

passport.use(new WeiboStrategy({
  clientID    : config.weiboAuth.appkey
  clientSecret: config.weiboAuth.secret
  callbackURL : config.weiboAuth.oauth_callback_url
  passReqToCallback: true
}, (req, token, refreshToken, profile, done) ->
  logger.info "Weibo profile"
  logger.info profile
  if req.user?
    user = req.user

    user.weibo.id    = profile.id
    user.weibo.token = token
    user.weibo.name  = profile.displayName

    user.save (err) ->
      if err then return done err

      done null, user
  else
    User.findOne {'weibo.id': profile.id}, (err, user) ->
      if err then return done err

      #如果用户未绑定，则将授权信息传给前端，完成绑定
      unless user
        payload =
          weibo_id   : profile.id
          weibo_token: token
          weibo_name : profile.displayName
        return done null, false, payload

      user.weibo.token = token
      user.weibo.name  = profile.displayName

      user.save (err) ->
        if err then return done err

        done null, user
))

passport.use(new QQStrategy({
  clientID    : config.qqAuth.appkey
  clientSecret: config.qqAuth.secret
  callbackURL : config.qqAuth.oauth_callback_url
  passReqToCallback: true
}, (req, token, refreshToken, profile, done) ->
  logger.info "QQ profile"
  logger.info profile
  if req.user?
    user = req.user

    user.qq.id    = profile.id
    user.qq.token = token
    user.qq.name  = profile.nickname

    user.save (err) ->
      if err then return done err

      done null, user
  else
    User.findOne {'qq.id': profile.id}, (err, user) ->
      if err then return done err
      unless user then return done null, false, { message: '该用户尚未绑定社交登录' }

      user.qq.token = token
      user.qq.name  = profile.nickname

      user.save (err) ->
        if err then return done err

        done null, user
))
