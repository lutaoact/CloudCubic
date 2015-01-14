//删除users的email唯一索引
db.users.dropIndex("email_1");

//删除掉email和orgId上的唯一索引，因为微信授权登录的时候，email为空，会导致索引失败
//db.users.dropIndex('email_1_orgId_1');

//courses数据迁移：将course的orgId设置为相应category的orgId
db.courses.find().forEach(function(course) {
  var category = db.categories.findOne({_id: course.categoryId});
  print(category.orgId);
  db.courses.update({_id: course._id}, {$set: {orgId: category.orgId}});
});

print("migrating classe data...")
db.classes.find().forEach(function(classe){
  print("classe.id: " + classe._id);
  var courses = db.courses.find({"classes" : classe._id});
  
  if(courses != null && courses.length() > 0) {
    // set classe's courseId for first course
    print("course id: " + courses[0]._id);
    db.classes.update({_id: classe._id}, {$set: {courseId: courses[0]._id}});

    // clone classes for other courses and set courseId for each copy
    delete classe._id;
    for (var i = 1; i < courses.length(); i++) {
      print("course id: " + courses[i]._id);
      classe.courseId = courses[i]._id;
      db.classes.insert(classe);
    }
  }
});
print("migrating classe data completed")

// unset classes field 
print("unset classes for course...")
db.courses.update({}, {$unset: {classes: ''}}, {multi: true});


//重命名dis_topics为topics
db.dis_topics.renameCollection('topics');

//根据course的name字段，创建相同名称的forum
//然后在topics表中，删除courseId字段，并设置为相应的forumId的值
db.courses.find().forEach(function(course) {
  print("course.id: " + course._id + ", name: " + course.name)
  admin = db.users.findOne({role: 'admin', orgId: course.orgId});
  print("admin._id: " + admin._id);

  //新建forum
  var forum = {
    postBy: admin._id,
    name: "来自课程-" + course.name,
    orgId: admin.orgId,
    categoryId: course.categoryId,
    logo: course.thumbnail,
    deleteFlag: false,
    created: course.created,
    modified: course.modified,
  };
  print("forum for inserting forums");
  printjson(forum);
  db.forums.save(forum);
  print("forum._id: " + forum._id);

  //设置course的forumId
  db.courses.update({_id: course._id}, {$set: {forumId: forum._id}});

  //给topics设置forumId
  db.topics.update({courseId: course._id}, {$set: {forumId: forum._id}, $unset: {courseId: ''}}, {multi: true});
});

// 删除所有未包含orgId的forum
//db.forums.remove({orgId: null})

//设置topics的viewersNum字段，让其值等于viewers字段的元素个数
db.topics.find().forEach(function(topic) {
  db.topics.update({_id: topic._id}, {$set: {viewersNum: topic.viewers.length, commentsNum: topic.repliesNum}});
});


db.dis_replies.find().forEach(function(dis_reply){
  var comment = {
    author: dis_reply.postBy,
    content: dis_reply.content,
    type: 1,
    belongTo: dis_reply.topicId,
    likeUsers: dis_reply.voteUpUsers,
    tags: [],
    deleteFlag: false,
    created: dis_reply.created,
    modified: dis_reply.modified,
  };
  db.comments.save(comment);
});
db.dis_replies.drop();

//lecture中新增courseId字段
db.courses.find().forEach(function(course) {
  print("courseId: " + course._id);
  course.lectureAssembly.forEach(function(lectureId) {
    print("\tlectureId: " + lectureId);
    db.lectures.update({_id: lectureId}, {$set: {courseId: course._id}});
  });
});

//将schedule中的start, end, until字段迁移到相应的classe中
db.schedules.find().forEach(function(schedule) {
  db.classes.update({_id: schedule.classe}, {$push: {schedules: {'start': schedule.start, 'end': schedule.end, 'until': schedule.until}}});
});

// remove all notices
db.notices.remove({})
