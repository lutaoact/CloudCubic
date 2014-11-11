/**
 * Created by zhenkunou on 14-11-11.
 */
db.users.dropIndex("username_1");

//move user username to email if email is undefined
db.users.find().forEach(function(user) {
  var noEmail = user.email == null || user.email.indexOf('@') == -1;
  if (noEmail) {
    user.email = user.username;
    db.users.update({_id: user._id}, user);
  };
});
