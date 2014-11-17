require '../common/init'
passport = require 'passport'

User = _u.getModel 'user'
WeiboStrategy = require('passport-weibo').Strategy

passport.use(new WeiboStrategy({
  clientID    : config.weiboAuth.appkey,
  clientSecret: config.weiboAuth.secret,
  callbackURL : config.weiboAuth.oauth_callback_url,
  passReqToCallback: true
}, (req, token, refreshToken, profile, done) ->
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
      unless user then return done null, false, { message: '该用户尚未绑定社交登录' }

      user.weibo.token = token
      user.weibo.name  = profile.displayName

      user.save (err) ->
        if err then return done err

        done null, user
))
