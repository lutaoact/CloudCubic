db.forums.find().forEach(function(forum) {
  var topics = db.topics.find({forumId: forum._id});
  db.forums.update({_id : forum._id}, {$set : {postsCount : topics.length()}});
});
