'use strict'

Org = _u.getModel "organization"
User = _u.getModel "user"
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

  countUserPromise = User.countQ orgId: orgId
  countCoursePromise = (
    Category.findQ {orgId: orgId, deleteFlag: $ne: true}, "_id"
    .then (categories) ->
      ids = _.pluck categories, '_id'
      Course.countQ categoryId: $in: ids
  )
  countTeacherPromise = User.countQ orgId: orgId, role: 'teacher'
  findAdminPromise = User.findQ orgId: orgId, role: 'admin'

  Q.all [
    countUserPromise
    countCoursePromise
    countTeacherPromise
    findAdminPromise
  ]
  .then (result) ->
    res.send
      users: result[0]
      courses: result[1]
      teachers: result[2]
      admin: result[3]
  .catch next
  .done()
