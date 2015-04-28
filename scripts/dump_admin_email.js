db.users.find({role: 'admin'}).forEach(function(user) {
  if (/@/.test(user.email)) {
    print(user.email);
  }
});
