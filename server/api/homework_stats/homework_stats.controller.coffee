'use strict'

CourseUtils = _u.getUtils 'course'
HomeworkAnswer = _u.getModel 'homework_answer'
StatsUtils = _u.getUtils 'stats'
User = _u.getModel 'user'
Classe = _u.getModel 'classe'

calLectureStats = (lecture, summary, studentsNum, studentsList, userId) ->
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
  condition.userId = userId if userId?
  condition.userId = $in : studentsList if studentsList? 

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

calStats = (user, courseId, studentsNum, studentsList, userId) ->
  finalStats = {}
  summary =
    questionsLength: 0
    correctNum: 0
    percent: 0

  if studentsNum is 0
    return Q.reject
      status : 403
      errCode : ErrCode.EmptyClass
      errMsg : 'Empty class'
    
  CourseUtils.getAuthedCourseById user, courseId
  .then (course) ->
    course.populateQ 'lectureAssembly', 'name homeworks'
  .then (course) ->
    lectures = course.lectureAssembly
    
    Q.all _.map lectures, (lecture) ->
      calLectureStats lecture, summary, studentsNum, studentsList, userId 
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
  role = me.role

  courseId = req.query.courseId
  classeId = req.query.classeId
  queryUserId = req.query.studentId ? req.query.userId

  (switch role
    when 'student'
      calStats me, courseId, 1, null, me.id
    when 'teacher'
      if queryUserId? # calculate stats for one person
        calStats me, courseId, 1, null, queryUserId
      else
        if classeId? # calculate stats for a class
          Classe.findByIdQ classeId
          .then (classe) ->
            studentsNum = classe.students.length
            studentsList = classe.students
            calStats me, courseId, studentsNum, studentsList
        else # calculate stats for a course
          CourseUtils.getStudentsNum me, courseId
          .then (studentsNum) ->
            calStats me, courseId, studentsNum
    when 'admin'
      tmpResult = {}
      queryUserId ?= me.id
      User.findByIdQ queryUserId
      .then (queryUser) ->
        if me.orgId.toString() isnt queryUser.orgId.toString()
          return Q.reject
            status : 403
            errCode : ErrCode.NotSameOrg
            errMsg : 'not the same org'

        tmpResult.queryUser = queryUser
      .then () ->
        CourseUtils.getAuthedCourseById me, courseId
      .then () ->
        CourseUtils.getStudentsNum tmpResult.queryUser, courseId
      .then (num) ->
        calStats tmpResult.queryUser, courseId, num
  ).then (statsResult) ->
    res.json 200, statsResult
  , next
