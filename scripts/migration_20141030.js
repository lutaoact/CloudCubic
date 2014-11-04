//删除categories和classes的name_1索引
db.categories.dropIndex('name_1');
db.classes.dropIndex('name_1');

//move slides to files for lectures
db.lectures.find().forEach(function(lecture) {
  var noFiles = lecture.files == null || lecture.files.length == 0;
  var hasSlides = lecture.slides != null && lecture.slides.length > 0;
  if (noFiles && hasSlides) {
    lecture.files = [{
      fileName: 'PPT 1',
      fileContent: lecture.slides,
    }];
    db.lectures.update({_id: lecture._id}, lecture);
  }
});

db.lectures.find().forEach(function(lecture) {
  if (lecture.files != null) {
    lecture.files.forEach(function (file) {
      if (file.fileName != null && (file.fileName.indexOf('.doc') != -1 || file.fileName.indexOf('pdf') != -1)) {
        file.fileWidth = 598;
        file.fileHeight = 842;
      }
      else {
        file.fileWidth = 720;
        file.fileHeight = 540;
      }
    })
    db.lectures.update({_id: lecture._id}, lecture);
  }
});
