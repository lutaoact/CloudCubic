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
    Classe.findQ teachers: user._id
    .then (classes) ->
      courseIds = _.pluck classes, 'courseId'
      conditions = _id: courseId

      # 如果不是某个班级的老师，则必须是相应课程的owner才有权限
      unless ~_u.findIndex(courseIds, courseId)
        conditions.owners = user._id

      Course.findOne conditions
            .populate 'categoryId', 'orgId'
            .execQ()
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          status : 403
          errCode : ErrCode.CannotReadThisCourse
          errMsg : 'No course found or no permission to read it'

  checkStudent: (user, courseId) ->
    Classe.findQ students: user._id
    .then (classes) ->
      courseIds = _.pluck classes, 'courseId'
      unless _u.contains(courseIds, courseId)
        return Q.reject
          status : 403
          errCode: ErrCode.CannotReadThisCourse
          errMsg : '学生没有学习该课程'

      Course.findById courseId
            .populate 'categoryId', 'orgId'
            .execQ()
    .then (course) ->
      if course?
        return course
      else
        Q.reject
          status : 403
          errCode: ErrCode.NoCourse
          errMsg : '未找到相关课程'

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

  # 管理员可以查看该机构的所有课程
  getAdminCourses : (orgId) ->
    return Course.find orgId: orgId
    .populate 'owners', '_id name avatar'
    .execQ()

  getTeacherCourses : (teacherId) ->
    return Course.find owners : teacherId
    .populate 'owners', '_id name avatar'
    .execQ()

  # 找出学生所在的所有班级，然后取出courseId字段（会有重复），进而获取课程列表
  getStudentCourses : (studentId) ->
    Classe.findQ students: studentId
    .then (classes) ->
      courseIds = _.pluck classes, 'courseId'

      Course.find _id: $in: courseIds
      .populate 'owners', '_id name avatar'
      .execQ()

  getStudentsNum: (user, courseId, classeId) ->
    @getStudentIds.apply @, arguments
    .then (studentIds) ->
      unless studentIds.length
        return Q.reject
          status: 400
          errCode: ErrCode.NoStudentsHere
          errMsg: '所选的班级没有学生'

      return studentIds.length


  #获取参与指定课程的所有学生的id列表，若指定了班级，则只需要计算该班级即可
  getStudentIds: (user, courseId, classeId) ->
    if user.role is 'student'
      return Q([user._id])

    conditions = courseId: courseId
    conditions._id = classeId if classeId #如果提供了classeId，则只查找指定班级

    Classe.findQ conditions
    .then (classes) ->
      unless classes?.length
        return Q.reject
          status: 400
          errCode: ErrCode.NoClassesHere
          errMsg: "没有找到相应班级 classeId: #{classeId}, courseId: #{courseId}"

      return _u.union.apply _u, (_.pluck classes, 'students')


  # For update operations, such as update/destroy/publish, user has to be
  # either course owner or course's associated classes teacher
  buildWriteConditions : (req) ->
    courseId = req.params.id
    orgId = req.user.orgId
    userId = req.user.id
    conditions = {_id: courseId, orgId: orgId}

    Classe.findQ
      courseId : courseId
      teachers : userId
    .then (classes) ->
      unless classes? and classes.length > 0
        conditions.owners = req.user._id if req.user.role is 'teacher'
        return conditions
    .catch (err) ->
      logger.error 'Failed to find class', err

exports.CourseUtils = CourseUtils
