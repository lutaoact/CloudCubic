BaseUtils = require('../../common/BaseUtils')

CourseUtils = _u.getUtils 'course'
Course      = _u.getModel 'course'
Lecture     = _u.getModel 'lecture'

class LectureUtils extends BaseUtils
  classname: 'LectureUtils'

  getAuthedLectureById: (user, lectureId) ->
    mCourse = undefined
    Course.findOneQ
      lectureAssembly: lectureId
    .then (course) ->
      mCourse = course
      CourseUtils.getAuthedCourseById user, mCourse._id
    .then (course) ->
      Lecture.findByIdQ lectureId
    .then (lecture) ->
      unless lecture
        return Q.reject
          status: 404
          errCode: ErrCode.NoLecture
          errMsg: '课时不存在'

      return lecture


  checkAuthForLecture: (user, lecture) ->
    Course.findOneQ
      lectureAssembly: lecture._id
    .then (course) ->
      mCourse = course
      CourseUtils.getAuthedCourseById user, mCourse._id
    .then () ->
      return lecture


exports.LectureUtils = LectureUtils
