var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;
var WeiboStrategy = require('passport-weibo').Strategy

exports.setup = function (User, config) {
  passport.use(new LocalStrategy({
      usernameField: 'email',
      passwordField: 'password' // this is the virtual field on the model
    },
    function(email, password, done) {
      User.findOne({
        email: email.toLowerCase()
      }, function(err, user) {
        if (err) return done(err);

        if (!user || !user.authenticate(password)) {
          return done(null, false, { message: '登录邮箱或密码错误，请重新填写' });
        }
        if (user.status == 0) {
          return done(null, false, { message: '登录邮箱未认证', unactivated: true});
        }
        return done(null, user);
      });
    }
  ));
};
