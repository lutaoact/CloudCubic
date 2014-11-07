require '../server/common/init'

User = _u.getModel 'user'
superUser =
  username: 'coding'
  email: 'coding'
  password: 'coding'
  role: 'super'

User.createQ superUser
.then (user) ->
  console.log user
, (err) ->
  console.log err
