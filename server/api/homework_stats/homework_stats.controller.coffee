'use strict'

CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'
StatsUtils = _u.getUtils 'stats'
User = _u.getModel 'user'
Classe = _u.getModel 'classe'

calLectureStats = (lecture, summary, studentsNum, studentsList) ->
  tmpResult = {}
  questionIds = lecture.homeworks

  lectureStat =
    lectureId: lecture.id
    name: lecture.name
    questionsLength: questionIds.length
    correctNum: 0
    percent: 0

  condition =
    lectureId : lecture._id
  condition.userId = $in : studentsList

  HomeworkAnswer.findQ condition
  .then (answers) ->
    tmpResult.answers = answers
    StatsUtils.buildQAMap questionIds
  .then (qaMap) ->
    lectureStat.correctNum =
      StatsUtils.computeCorrectNumByHKAnswers qaMap, tmpResult.answers

    summary.questionsLength += lectureStat.questionsLength
    summary.correctNum += lectureStat.correctNum
    
    if lectureStat.correctNum is 0
      lectureStat.percent = 0
    else
      lectureStat.percent = 
        lectureStat.correctNum * 100 //(studentsNum * lectureStat.questionsLength)

    return lectureStat
  , (err) ->
    Q.reject err

calStats = (user, courseId, studentsList) ->
  finalStats = {}
  summary =
    questionsLength: 0
    correctNum: 0
    percent: 0

  studentsNum = studentsList?.length
  if studentsNum is 0
    return Q.reject
      status : 403
      errCode : ErrCode.NoStudentsHere
      errMsg : 'No student to calculate statistics data'
    
  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name homeworks'
  .then (course) ->
    lectures = course.lectureAssembly
    
    Q.all _.map lectures, (lecture) ->
      calLectureStats lecture, summary, studentsNum, studentsList
  .then (statsData) ->
    finalStats = _.indexBy statsData, 'lectureId'

    if summary.correctNum is 0
      summary.percent = 0
    else
      summary.percent = summary.correctNum * 100 // (summary.questionsLength * studentsNum)

    finalStats.summary = summary
    return finalStats

exports.show = (req, res, next) ->
  me = req.user

  courseId = req.query.courseId
  classeId = req.query.classeId
  queryUserId = req.query.studentId ? req.query.userId
  
  Q(if queryUserId?
      [queryUserId]
    else
      CourseUtils.getStudentIds(me, courseId, classeId)
  )
  .then (studentsList) ->
    calStats me, courseId, studentsList
  .then (statsResult) ->
    res.json 200, statsResult
  .catch next
  .done() 
