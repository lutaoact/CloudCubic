'use strict'

Org = _u.getModel "organization"
User = _u.getModel "user"
Classe = _u.getModel "classe"
Course = _u.getModel "course"
Category = _u.getModel 'category'
OrgUtils  = _u.getUtils 'organization'

exports.index = (req, res, next) ->
  Org.findAllQ()
  .then (orgs) ->
    res.send orgs
  .catch next
  .done()


exports.show = (req, res, next) ->
  orgId = req.params.id

  findAdminPromise    = User.findQ orgId: orgId, role: 'admin'
  countUserPromise    = User.countQ orgId: orgId
  countTeacherPromise = User.countQ orgId: orgId, role: 'teacher'
  countStudentPromise = User.countQ orgId: orgId, role: 'student'
  countClassePromise = Classe.countQ orgId: orgId
  countCoursePromise  = (
    Category.findQ {orgId: orgId, deleteFlag: $ne: true}, "_id"
    .then (categories) ->
      ids = _.pluck categories, '_id'
      Course.countQ categoryId: $in: ids
  )

  Q.all [
    findAdminPromise
    countUserPromise
    countTeacherPromise
    countStudentPromise
    countClassePromise
    countCoursePromise
  ]
  .then (result) ->
    res.send
      admins   : result[0]
      nUsers   : result[1]
      nTeachers: result[2]
      nStudents: result[3]
      nClasses : result[4]
      nCourses : result[5]
  .catch next
  .done()
