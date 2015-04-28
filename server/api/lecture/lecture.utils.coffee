BaseUtils = require('../../common/BaseUtils')

CourseUtils = _u.getUtils 'course'
Course      = _u.getModel 'course'
Lecture     = _u.getModel 'lecture'
Classe     = _u.getModel 'classe'

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


  isFree: (lecture) ->
    return Q(true) if lecture.isFreeTry
    Course.findOneQ
      lectureAssembly: lecture._id
    .then (course)->
      Classe.findQ courseId: course._id
    .then (classes) ->
      console.log classes
      # check if one of the class is free
      isFreeClasse = _.any classes, (classe)->
        console.log classe.price
        return (classe.price == 0) && (classe.deleteFlag == false)
      console.log isFreeClasse
      return isFreeClasse

exports.LectureUtils = LectureUtils
