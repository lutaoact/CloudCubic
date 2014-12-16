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

    console.log 'body', JSON.stringify(req.body)

    orgId = req.org?._id ? req.body.orgId

    conditions = email: email
    conditions.orgId = orgId if orgId?

    User.find conditions
    .populate 'orgId'
    .exec (err, users) ->
      if err
        return done(err)

      logger.info 'found users', users.length

      if users.length > 1
        return done(null, false, { message: '该邮箱注册了多个账户，请选择您要登录的账户' , loginUsers: users})

      user = users[0]

      if !user or !user.authenticate(password)
        return done(null, false, { message: '登录邮箱或密码错误，请重新填写' })

      if user.status == 0
        return done(null, false, { message: '登录邮箱未认证', unactivated: true})

      return done(null, user)
  )
