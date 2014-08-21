(function() {
  'use strict';
  var BaseModel, ObjectId, Schema, authTypes, crypto, mongoose, setupUserSchema;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  ObjectId = Schema.ObjectId;

  crypto = require('crypto');

  authTypes = ['google'];

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.User = BaseModel.subclass({
    classname: 'User',
    initialize: function($super) {
      this.schema = new Schema({
        avatar: {
          type: String
        },
        email: {
          type: String,
          lowercase: true
        },
        name: {
          type: String
        },
        hashedPassword: {
          type: String
        },
        provider: {
          type: String
        },
        role: {
          type: String,
          "default": 'employee'
        },
        salt: {
          type: String
        },
        status: {
          type: String
        },
        resetPasswordToken: {
          type: String
        },
        resetPasswordExpires: {
          type: Date
        }
      });
      setupUserSchema(this.schema);
      return $super();
    }
  });

  setupUserSchema = function(UserSchema) {
    var validatePresenceOf;
    UserSchema.virtual('password').set(function(password) {
      this._password = password;
      this.salt = this.makeSalt();
      return this.hashedPassword = this.encryptPassword(password);
    }).get(function() {
      return this._password;
    });
    UserSchema.virtual('profile').get(function() {
      return {
        'name': this.name,
        'role': this.role,
        'avatar': this.avatar
      };
    });
    UserSchema.virtual('token').get(function() {
      return {
        '_id': this._id,
        'role': this.role
      };
    });
    UserSchema.path('email').validate(function(email) {
      return email.length;
    }, 'Email cannot be blank');
    UserSchema.path('hashedPassword').validate(function(hashedPassword) {
      return hashedPassword.length;
    }, 'Password cannot be blank');
    UserSchema.path('email').validate(function(value, respond) {
      var self;
      self = this;
      return this.constructor.findOne({
        email: value
      }, function(err, user) {
        if (err) {
          throw err;
        }
        if (user) {
          if (self.id === user.id) {
            return respond(true);
          }
          return respond(false);
        }
        return respond(true);
      });
    }, 'The specified email address is already in use.');
    validatePresenceOf = function(value) {
      return value && value.length;
    };
    UserSchema.pre('save', function(next) {
      if (!this.isNew) {
        next();
      }
      if (!validatePresenceOf(this.hashedPassword) && authTypes.indexOf(this.provider) === -1) {
        return next(new Error('Invalid password'));
      } else {
        return next();
      }
    });
    return UserSchema.methods = {

      /*
        Authenticate - check if the passwords are the same
        @param {String} plainText
        @return {Boolean}
        @api public
       */
      authenticate: function(plainText) {
        return this.encryptPassword(plainText) === this.hashedPassword;
      },

      /*
       Make salt
       @return {String}
       @api public
       */
      makeSalt: function() {
        return crypto.randomBytes(16).toString('base64');
      },

      /*
        Encrypt password
        @param {String} password
        @return {String}
        @api public
       */
      encryptPassword: function(password) {
        var salt;
        if (!password || !this.salt) {
          '';
        }
        salt = new Buffer(this.salt, 'base64');
        return crypto.pbkdf2Sync(password, salt, 10000, 64).toString('base64');
      }
    };
  };

}).call(this);

//# sourceMappingURL=user.model.js.map
