//删除users的email唯一索引
db.users.dropIndex("email_1");

//courses数据迁移：将course的orgId设置为相应category的orgId
db.courses.find().forEach(function(course) {
  var category = db.categories.findOne({_id: course.categoryId});
  print(category.orgId);
  db.courses.update({_id: course._id}, {$set: {orgId: category.orgId}});
});

//根据course中classes的值，给相应的classe加上courseId字段
db.courses.find().forEach(function(course) {
  print("course.id: " + course._id)
  if (course.classes && course.classes.length) {
    db.classes.find({_id: {$in: course.classes}}).forEach(function(classe) {
      print("\tclasse._id: " + classe._id + ", classe.name: " +  classe.name);
      db.classes.update({_id: classe._id}, {$set: {courseId: course._id}});
    });
    print("\n");
  }
});
db.courses.update({}, {$unset: {classes: ''}}, {multi: true});

//根据course的name字段，创建相同名称的forum
//然后在dis_topics表中，删除courseId字段，并设置为相应的forumId的值
db.courses.find().forEach(function(course) {
  print("course.id: " + course._id + ", name: " + course.name)
  admin = db.users.findOne({role: 'admin', orgId: course.orgId});
  print("admin._id: " + admin._id);

  //新建forum
  var forum = {
    postBy: admin._id,
    name: course.name,
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

  //给dis_topics设置forumId
  db.dis_topics.update({courseId: course._id}, {$set: {forumId: forum._id}, $unset: {courseId: ''}}, {multi: true});
});

// 删除所有未包含orgId的forum
db.forums.remove({orgId: null})

//设置dis_topics的viewersNum字段，让其值等于viewers字段的元素个数
db.dis_topics.find().forEach(function(disTopic) {
  db.dis_topics.update({_id: disTopic._id}, {$set: {viewersNum: disTopic.viewers.length, commentsNum: disTopic.repliesNum}});
});


db.dis_replies.find().forEach(function(dis_reply){
  var comment = {
    author: dis_reply.postBy,
    content: dis_reply.content,
    type: 1,
    belongTo: dis_reply.disTopicId,
    likeUsers: dis_reply.voteUpUsers,
    tags: [],
    deleteFlag: false,
    created: dis_reply.created,
    modified: dis_reply.modified,
  };
  db.comments.save(comment);
});

//courses数据迁移：将course的isPublished设置为 true
db.courses.find().forEach(function(course) {
  db.courses.update({_id: course._id}, {$set: {isPublished: true}});
});

//lecture中新增courseId字段
db.courses.find().forEach(function(course) {
  print("courseId: " + course._id);
  course.lectureAssembly.forEach(function(lectureId) {
    print("\tlectureId: " + lectureId);
    db.lectures.update({_id: lectureId}, {$set: {courseId: course._id}});
  });
});