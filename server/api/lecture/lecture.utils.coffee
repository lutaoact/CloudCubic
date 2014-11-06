BaseUtils = require('../../common/BaseUtils')

class LectureUtils extends BaseUtils
  classname: 'LectureUtils'

  getAuthedLectureById: (user, lectureId) ->
    CourseUtils = _u.getUtils 'course'
    Course      = _u.getModel 'course'
    Lecture     = _u.getModel 'lecture'

    mCourse = undefined
    Course.findOneQ
      lectureAssembly: lectureId
    .then (course) ->
      mCourse = course
      CourseUtils.getAuthedCourseById user, mCourse._id
    .then (course) ->
      Lecture.findOne
        _id: lectureId
      .execQ()

exports.LectureUtils = LectureUtils
