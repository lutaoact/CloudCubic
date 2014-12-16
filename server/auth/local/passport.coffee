passport = require('passport')
LocalStrategy = require('passport-local').Strategy
WeiboStrategy = require('passport-weibo').Strategy

exports.setup = (User, config) ->
  passport.use new LocalStrategy(
    usernameField : 'email'
    passwordField : 'password' # this is the virtual field on the model
    passReqToCallback: true
  , (req, email, password, done) ->
    logger.info 'passport verify: orgId: ' + req.org?._id + ', email: ' + email + ', password: ' + password

    conditions = email: email
    conditions.orgId = req.org?._id if req.org?._id?

    User.findOne conditions, (err, user) ->
      if err
        return done(err)

      if !user or !user.authenticate(password)
        return done(null, false, { message: '登录邮箱或密码错误，请重新填写' })

      if user.status == 0
        return done(null, false, { message: '登录邮箱未认证', unactivated: true})

      return done(null, user)
  )
