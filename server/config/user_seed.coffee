require '../common/init'

orgId   = '333333333333333333333%03d'
superId = Const.SuperId
name    = 'Student%s'
email   = 'student%s@cloud3edu.cn'

User = _u.getModel 'user'

module.exports =
  user: (for i in [0..999]
    _id: _s.sprintf superId, i
    provider: 'local'
    role: 'student'
    name: _s.sprintf name, i
    email: _s.sprintf email, i
    password: 'student'
    orgId: _s.sprintf orgId, 999
    avatar: 'http://lorempixel.com/128/128/people/4'
  )

User.createQ module.exports.user
.then (users) ->
  console.log users.length
  console.log 'load data success'
, console.error