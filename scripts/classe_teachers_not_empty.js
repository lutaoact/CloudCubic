db.classes.find().forEach(function(classe) {
  print("classe._id: " + classe._id);
  if (classe.teachers && classe.teachers.length > 0) { return; }

  print("classe.teachers is empty: " + classe.teachers);

  var course = db.courses.findOne({_id: classe.courseId});
  printjson(course.owners);
  db.classes.update({_id: classe._id}, {$set: {teachers: course.owners}});
});
