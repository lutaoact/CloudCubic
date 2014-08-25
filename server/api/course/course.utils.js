(function() {
  var BaseUtils, Course;

  BaseUtils = require('../../common/BaseUtils').BaseUtils;

  Course = _u.getModel('course');

  exports.CourseUtils = BaseUtils.subclass({
    classname: 'CourseUtils',
    getAuthedCourseById: function(user, courseId, cb) {
      switch (user.role) {
        case 'student':
          return this.checkStudent(user._id, courseId);
        case 'teacher':
          return this.checkTeacher(user._id, courseId);
      }
    },
    checkTeacher: function(teacherId, courseId) {
      return Course.findOneQ({
        _id: courseId,
        owners: teacherId
      }).then(function(course) {
        if (course != null) {
          return course;
        } else {
          return Q.reject({
            errCode: ErrCode.CannotReadThisCourse,
            errMsg: 'do not have permission on this course'
          });
        }
      }, function(err) {
        return Q.reject(err);
      });
    },
    checkStudent: function(studentId, courseId) {
      var Classe;
      Classe = _u.getModel('classe');
      return Classe.findOneQ({
        students: studentId
      }).then(function(classe) {
        return Course.findOneQ({
          _id: courseId,
          classes: classe._id
        });
      }).then(function(course) {
        if (course != null) {
          return course;
        } else {
          return Q.reject({
            errCode: ErrCode.CannotReadThisCourse,
            errMsg: 'do not have permission on this course'
          });
        }
      }, function(err) {
        return Q.reject(err);
      });
    },
    getTeacherCourses: function(teacherId) {
      return Course.find({
        owners: teacherId
      }).populate('classes', '_id name orgId yearGrade').then(function(courses) {
        if (courses != null) {
          return courses;
        }
      }, function(err) {
        return Q.reject(err);
      });
    },
    getStudentCourses: function(studentId) {
      var Classe;
      Classe = _u.getModel('classe');
      return Classe.findOneQ({
        students: studentId
      }).then(function(classe) {
        return Course.find({
          classes: classe._id
        });
      }).then(function(courses) {
        if (courses != null) {
          return courses;
        }
      }, function(err) {
        return Q.reject(err);
      });
    }
  });

}).call(this);

//# sourceMappingURL=course.utils.js.map
