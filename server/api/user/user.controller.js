(function() {
  'use strict';
  var User, config, fs, helpers, http, jwt, passport, path, qiniu, qiniuDomain, validationError, xlsx, _;

  User = require('./user.model');

  passport = require('passport');

  config = require('../../config/environment');

  jwt = require('jsonwebtoken');

  qiniu = require('qiniu');

  helpers = require('../../common/helpers');

  path = require('path');

  _ = require('lodash');

  fs = require('fs');

  http = require('http');

  xlsx = require('node-xlsx');

  qiniu.conf.ACCESS_KEY = config.qiniu.access_key;

  qiniu.conf.SECRET_KEY = config.qiniu.secret_key;

  qiniuDomain = config.qiniu.domain;

  validationError = function(res, err) {
    return res.json(422, err);
  };


  /*
    Get list of users
    restriction: 'admin'
   */

  exports.index = function(req, res) {
    return User.find({}, '-salt -hashedPassword', function(err, users) {
      if (err) {
        res.send(500, err);
      }
      return res.json(200, users);
    });
  };


  /*
    Creates a new user
   */

  exports.create = function(req, res, next) {
    var newUser;
    newUser = new User(req.body);
    newUser.provider = 'local';
    return newUser.save(function(err, user) {
      var token;
      if (err) {
        return validationError(res, err);
      }
      token = jwt.sign({
        _id: user._id
      }, config.secrets.session, {
        expiresInMinutes: 60 * 5
      });
      return res.json({
        token: token
      });
    });
  };


  /*
    Get a single user
   */

  exports.show = function(req, res, next) {
    var userId;
    userId = req.params.id;
    return User.findById(userId, function(err, user) {
      if (err) {
        next(err);
      }
      if (!user) {
        res.send(401);
      }
      return res.json(user.profile);
    });
  };


  /*
    Deletes a user
    restriction: 'admin'
   */

  exports.destroy = function(req, res) {
    return User.findByIdAndRemove(req.params.id, function(err, user) {
      if (err) {
        res.send(500, err);
      }
      return res.send(200, user);
    });
  };


  /*
    Change a users password
   */

  exports.changePassword = function(req, res, next) {
    var newPass, oldPass, userId;
    userId = req.user._id;
    oldPass = String(req.body.oldPassword);
    newPass = String(req.body.newPassword);
    return User.findById(userId, function(err, user) {
      if (user.authenticate(oldPass)) {
        user.password = newPass;
        return user.save(function(err) {
          if (err) {
            validationError(res, err);
          }
          return res.send(200);
        });
      } else {
        return res.send(403);
      }
    });
  };


  /*
    Get my info
   */

  exports.me = function(req, res, next) {
    var userId;
    userId = req.user._id;
    return User.findOne({
      _id: userId
    }, '-salt -hashedPassword', function(err, user) {
      if (err) {
        next(err);
      }
      if (!user) {
        res.json(401);
      }
      return res.json(user);
    });
  };


  /*
    Update user
   */

  exports.update = function(req, res) {
    if (_.has(req.body, '_id')) {
      delete req.body._id;
    }
    if (_.has(req.body, 'password')) {
      delete req.body.password;
    }
    return User.findById(req.params.id, function(err, user) {
      var updated;
      if (err) {
        return handleError(err);
      }
      if (!user) {
        return res.send(404);
      }
      updated = _.merge(user, req.body);
      return updated.save(function(err) {
        if (err) {
          return handleError(err);
        }
        return res.json(200, user);
      });
    });
  };


  /*
    Bulk import users from excel sheet uploaded by client
   */

  exports.bulkImport = function(req, res, next) {
    var baseUrl, destFile, file, orgId, policy, request, resourceKey, tempUrl;
    resourceKey = req.body.key;
    orgId = req.body.orgId;
    baseUrl = qiniu.rs.makeBaseUrl(qiniuDomain, resourceKey);
    policy = new qiniu.rs.GetPolicy();
    tempUrl = policy.makeRequest(baseUrl);
    destFile = config.tmpDir + path.sep + 'user_list.xlsx';
    file = fs.createWriteStream(destFile);
    return request = http.get(tempUrl, function(stream) {
      stream.pipe(file);
      return file.on('finish', function() {
        return file.close(function() {
          var data, importReport, obj, userList;
          console.log('Start parsing file...');
          obj = xlsx.parse(destFile);
          data = obj.worksheets[0].data;
          if (!data) {
            console.error('Failed to parse user list file or empty file');
            res.send(500);
            return;
          }
          userList = _.rest(data);
          importReport = {
            total: 0,
            success: [],
            failure: []
          };
          return _.forEach(userList, function(userItem) {
            var newUser;
            console.log('UserItem is ...');
            console.log(userItem);
            newUser = new User({
              name: userItem[0].value,
              email: userItem[1].value,
              role: userItem[2].value,
              password: userItem[1].value,
              orgId: orgId
            });
            return newUser.save(function(err, user) {
              importReport.total += 1;
              if (err) {
                console.error('Failed to save user ' + newUser.name);
                importReport.failure.push(err.errors);
              } else {
                console.log('Created user ' + newUser.name);
                importReport.success.push('Created user ' + newUser.name);
              }
              if (importReport.total === userList.length) {
                return res.json(200, importReport);
              }
            });
          });
        });
      });
    }).on('error', function(err) {
      console.error('There is an error while downloading file from ' + url);
      fs.unlink(dest);
      return res.send(500);
    });
  };


  /*
   Authentication callback
   */

  exports.authCallback = function(req, res, next) {
    return res.redirect('/');
  };

}).call(this);

//# sourceMappingURL=user.controller.js.map
