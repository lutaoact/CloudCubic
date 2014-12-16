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
