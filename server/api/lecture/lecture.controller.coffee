
#
# * Using Rails-like standard naming convention for endpoints.
# * GET     /lecture              ->  index
# * POST    /lecture              ->  create
# * GET     /lecture/:id          ->  show
# * PUT     /lecture/:id          ->  update
# * DELETE  /lecture/:id          ->  destroy
#

Lecture = _u.getModel "lecture"
Course = _u.getModel "course"
CourseUtils = _u.getUtils 'course'
LectureUtils = _u.getUtils 'lecture'
Classe = _u.getModel 'classe'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'
request = require 'request'
getMediaService = require('../../common/azureMS').getMediaService

WrapRequest = new (require '../../utils/WrapRequest')(Lecture)

exports.index = (req, res, next) ->
  courseId = req.query.courseId

  Course.getById courseId
  .then (course) ->
    conditions = {_id: {$in: course.lectureAssembly}}
    options =
      limit: req.query.limit
      from: req.query.from
      sort: req.query.sort
    WrapRequest.wrapPageIndex req, res, next, conditions, options


exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  Lecture.findOneQ conditions, null, {lean: true}
  .then (lecture) ->
    console.log lecture
    if lecture.isFreeTry
      return lecture

    unless req.user
      return Q.reject
        status: 403
        errCode: ErrCode.NotFreeLecture
        errMsg: '未登录用户无法查看非免费课时'

    LectureUtils.checkAuthForLecture req.user, lecture
  .then (lecture) ->
    res.send lecture
  .catch next
  .done()


# TODO: add lectureID to classProcess's lectures automatically & keep the list order same as Course's lectureAssembly.
exports.create = (req, res, next) ->
  courseId = req.query.courseId
  tmpResult = {}
  data = req.body
  delete data._id
  CourseUtils.getAuthedCourseById req.user, courseId
  .then (course) ->
    tmpResult.course = course
    data.courseId = course._id
    Lecture.createQ data
  .then (lecture) ->
    tmpResult.lecture = lecture
    tmpResult.course.lectureAssembly.push lecture._id
    do tmpResult.course.saveQ #TODO: should rollback creating lecture part
  .then () ->
    Classe.find
      courseId: courseId
  .then (classes) ->
    Classe.getAllStudents _.pluck(classes, '_id')
  .then (studentIds) ->
    NoticeUtils.addLectureNotices studentIds, tmpResult.lecture._id
#  .then (notices) ->
#    SocketUtils.sendNotices notices if notices?
  .then () ->
    res.send tmpResult.lecture
  , next


exports.update = (req, res, next) ->
  lectureId = req.params.id
  updated = null
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    delete req.body._id  if req.body._id
    updated = _.extend lecture, req.body
    updated.markModified 'slides'
    updated.markModified 'keyPoints'
    updated.markModified 'quizzes'
    updated.markModified 'homeworks'
    if req.body.media? && config.assetsConfig[config.assetHost.uploadVideoType].serviceName == 'azure'
      auth =
        client_id: config.assetsConfig[config.assetHost.uploadVideoType].accountName
        client_secret: config.assetsConfig[config.assetHost.uploadVideoType].accountKey
        base_url: config.azure.serverAddress
        oauth_url: config.azure.acsBaseAddress
      assetId = req.body.media.split('/')[5]

      api = null
      apiDoneUpload = null
      getMediaService(auth)
      .then (azureMediaService)->
        api = azureMediaService
        apiDoneUpload = Q.nbind(api.media.doneUpload, api.media)
        apilistLocators = Q.nbind(api.rest.asset.listLocators, api.rest.asset)
        apilistLocators(assetId)
      .then (locators)->
        apiDoneUpload assetId, locators[0].toJSON().Id
  .then ()->
    updated.saveQ()
  .then ()->
    res.send updated
  , (err) ->
    next err


# TODO: delete from classProgress's lecturesStatus
exports.destroy = (req, res, next) ->
  lectureId = req.params.id
  LectureUtils.getAuthedLectureById req.user, lectureId
  .then (lecture) ->
    Lecture.removeQ
      _id : lectureId
  .then () ->
    Course.findOneQ
      lectureAssembly : lectureId
  .then (course) ->
    _.remove course.lectureAssembly
    , (id) ->
      id.toString() is lectureId
    course.markModified "lectureAssembly"
    course.save (err) ->
      next err if err
      res.send 204
  , next
