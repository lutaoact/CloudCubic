'use strict'

StatsUtils  = _u.getUtils 'stats'
LectureUtils = _u.getUtils 'lecture'
User        = _u.getModel 'user'
Question    = _u.getModel 'question'
HomeworkAnswer = _u.getModel 'homework_answer'
Course = _u.getModel "course"
CourseUtils = _u.getUtils 'course'
LectureUtils = _u.getUtils 'lecture'
Classe = _u.getModel 'classe'
findIndex = _u.findIndex


exports.questionStats = (req, res, next) ->
  lectureId = req.query.lectureId
  courseId = req.query.courseId
  classeId = req.query.classeId
  questionId = req.query.questionId
  type = req.query.type #quizzes or homeworks
  logger.info "Get stats for lecture #{lectureId}"

  studentsPromise = null
  if courseId
    studentsPromise = CourseUtils.getAuthedCourseById req.user, courseId
    .then (course) ->
      Classe.getStudentIdsByCourseId courseId
  else if classeId
    studentsPromise = Classe.getStudentIdsByClasseIds [classeId]
  else
    return next("need classeId or courseId")

  user = req.user
  Q.all [studentsPromise, LectureUtils.getAuthedLectureById user, lectureId]
  .spread (students, lecture) ->
    logger.info 'students:', students
    if findIndex(lecture.quizzes, questionId) >= 0 and type is 'quizzes'
      StatsUtils.getQuizStats lectureId, questionId, students
    else if findIndex(lecture.homeworks, questionId) >=0 and type is 'homeworks'
      StatsUtils.getHomeworkStats lectureId, questionId, students
    else
      throw new Error("question #{questionId} cannot find in lecture #{lectureId}")
  .then (result) ->
    res.send 200, result
  .fail next
  .done()
