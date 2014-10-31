//删除categories和classes的name_1索引
db.categories.dropIndex('name_1');
db.classes.dropIndex('name_1');

//move slides to files for lectures
db.lectures.find().forEach(function(lecture) {
  lecture.files = [{
    fileName: 'PPT 1',
    fileContent: lecture.slides,
  }];
  db.lectures.update({_id: lecture._id}, lecture);
});