require '../server/common/init'

User = _u.getModel 'user'

superUser =
  email: 'superuser'
  password: 'superuser'
  role: 'superuser'

User.createQ superUser
.then (user) ->
  console.log user
, (err) ->
  console.log err
