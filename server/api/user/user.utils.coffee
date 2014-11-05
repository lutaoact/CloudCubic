User = _u.getModel 'user'

class UserUtils
  check: (username) ->
    User.findBy username
    .then (user) ->
      if user?
        return Q.reject
          status : 400
          errCode : ErrCode.UsernameInUsed
          errMsg : 'username已被使用'


exports.UserUtils = UserUtils
