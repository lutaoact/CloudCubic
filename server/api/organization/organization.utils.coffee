Organization = _u.getModel 'organization'

courseThumbnail = 'http://7u2mnb.com1.z0.glb.clouddn.com/assets/images/60ea4c77.home_banner01_mac.png'
lectureThumbnail = 'http://pic.baike.soso.com/p/20111207/bki-20111207150829-916088691.jpg'

class OrganizationUtils
  check: (uniqueName) ->
    Organization.findByUniqueName uniqueName
    .then (org) ->
      if org?
        return Q.reject
          status : 400
          errCode : ErrCode.UniqueNameInUsed
          errMsg : 'uniqueName已被使用'

  init: (admin, org) ->
    Category = _u.getModel 'category'
    Classe = _u.getModel 'classe'
    Course = _u.getModel 'course'
    Lecture = _u.getModel 'lecture'

    tmpResult = {}
    timeString = new Date().toISOString()
    Category.createQ {name: '其它' + timeString, orgId: org._id}
    .then (category) ->
      tmpResult.category = category
      lectureData =
        name: '示例课时' + timeString
        thumbnail: lectureThumbnail
        desc: '这是示例课时，支持上传视频或者ppt作为课时内容'
        media: '/api/assets/videos/3/nb:cid:UUID:c6418209-e36d-4671-a5c1-502f89bff710/origin'
        isFreeTry: true
      Lecture.createQ lectureData
    .then (lecture) ->
      tmpResult.lecture = lecture
      courseData =
        name: '示例课程' + timeString
        orgId: org._id
        categoryId: tmpResult.category._id
        thumbnail: courseThumbnail
        info: '这是示例课程'
        lectureAssembly: [tmpResult.lecture._id]
        owners: [admin._id]

      Course.createQ courseData
    .then (course) ->
      tmpResult.course = course
      classeData =
        name: '示例班级' + timeString
        orgId: org._id
        courseId: tmpResult.course._id
        teachers: [admin._id]
        price: 0

      Classe.createQ classeData
    .then (classe) ->
      tmpResult.classe = classe
      return tmpResult
#    , (err) ->
#      logger.info err
#      return Q.reject(
#        err: err
#        idList:
#          categoryId: tmpResult.category?._id
#          lectureId : tmpResult.lecture?._id
#          courseId  : tmpResult.course?._id
#          classeId  : tmpResult.classe?._id
#      )


exports.OrganizationUtils = OrganizationUtils
