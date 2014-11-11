var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;

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

        if (!user) {
          return done(null, false, { message: '该邮箱还未注册' });
        }
        if (!user.authenticate(password)) {
          return done(null, false, { message: '登录密码错误' });
        }
        return done(null, user);
      });
    }
  ));
};
