'use strict'
require '../server/common/init'

User = _u.getModel 'user'

User.findQ email: {$exists:true}
.then (users) ->
  promises = for user in users
    console.log 'reset user password ' + user.email
    user.password = '123'
    user.saveQ()

  Q.all promises
.then ->
  console.log 'reset password done.'
, (err) ->
  console.log err
