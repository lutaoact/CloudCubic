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

exports.LectureUtils = LectureUtils
