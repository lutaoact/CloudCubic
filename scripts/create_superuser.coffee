require '../server/common/init'

User = _u.getModel 'user'

superUser =
  name: '超级管理员'
  email: 'superuser'
  password: '123'
  role: 'superuser'
  status: 1

User.removeQ email:superUser.email
.then ->
  User.createQ superUser
  .then (user) ->
    console.log user
  , (err) ->
    console.log err
