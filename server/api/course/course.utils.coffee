BaseUtils = require('../../common/BaseUtils')
Course = _u.getModel 'course'
Classe = _u.getModel 'classe'

class CourseUtils extends BaseUtils
  classname: 'CourseUtils'

  getAuthedCourseById: (user, courseId) ->
    switch user.role
      when 'student' then return @checkStudent user, courseId
      when 'teacher' then return @checkTeacher user, courseId
      when 'admin'   then return @checkAdmin   user, courseId

  checkTeacher: (user, courseId) ->
    Course.findOneQ
      _id: courseId
      owners: user._id
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          status : 403
          errCode : ErrCode.CannotReadThisCourse
          errMsg : 'No course found or no permission to read it'

  checkStudent: (user, courseId) ->
    Classe.findQ
      students: user._id
    .then (classes) ->
      classeIds = _.pluck classes, '_id'
      Course.findOneQ
        _id: courseId
        classes: $in: classeIds
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          status : 403
          errCode: ErrCode.CannotReadThisCourse
          errMsg : 'No course found or no permission to read it'

  checkAdmin : (user, courseId) ->
    Course.findById courseId
          .populate 'categoryId', 'orgId'
          .execQ()
    .then (course) ->
      if course?.categoryId?.orgId.toString() isnt user.orgId.toString()
        return Q.reject
          status : 403
          errCode: ErrCode.CannotReadThisCourse
          errMsg : 'No course found or no permission to read it'

      return course


  getTeacherCourses : (teacherId) ->
    Course.find
      owners : teacherId
    .populate 'classes', '_id name orgId yearGrade'
    .populate 'owners', '_id name avatar'
    .execQ()
    .then (courses) ->
      return courses
    , (err) ->
      Q.reject err

  getStudentCourses : (studentId) ->
    Classe = _u.getModel 'classe'
    Classe.findOneQ
      students: studentId
    .then (classe) ->
      Course.find
        classes : classe._id
      .populate 'owners', '_id name avatar'
      .execQ()
    .then (courses) ->
      return courses
    , (err) ->
      Q.reject err

  getStudentsNum: (user, courseId) ->
    if user.role is 'student'
      return Q(1)

    @getAuthedCourseById user, courseId
    .then (course) ->
      Classe.findQ _id: $in: course.classes
    .then (classes) ->
      return (_u.union.apply _u, (_.pluck classes, 'students')).length

exports.CourseUtils = CourseUtils
