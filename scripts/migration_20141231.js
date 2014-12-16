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
  db.classes.find({_id: {$in: course.classes}}).forEach(function(classe) {
    print("\tclasse._id: " + classe._id + ", classe.name: " +  classe.name);
    db.classes.update({_id: classe._id}, {$set: {courseId: course._id}});
  });
  print("\n");
});

//根据course的name字段，创建相同名称的forum
//然后在dis_topics表中，删除courseId字段，并设置为相应的forumId的值
db.courses.find().forEach(function(course) {
  print("course.id: " + course._id + ", name: " + course.name)
  admin = db.users.findOne({role: 'admin', orgId: course.orgId});
  print("admin._id: " + admin._id);

  //新建forum
  var forum = {
    postBy: admin._id,
    name: course.name
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
