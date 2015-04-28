'use strict'

Classe = _u.getModel 'classe'
User = _u.getModel 'user'

# 找出相应学生，加入指定班级
# 要求管理员与所操作学生必须属于同一org
exports.enrollStudent = (req, res, next) ->
  admin = req.user
  classeId  = req.body.classeId
  studentId = req.body.studentId

  logger.info "admin.orgId: #{admin.orgId}"
  logger.info "classeId: #{classeId}"
  logger.info "studentId: #{studentId}"

  tmpResult = {}
  Classe.getOneById classeId
  .then (classe) ->
    tmpResult.classe = classe
    User.getStudentById studentId
  .then (student) ->
    tmpResult.student = student
    console.log admin, student
    unless _u.isEqual(admin.orgId, student.orgId)
      return Q.reject
        status: 403
        errCode: ErrCode.NotSameOrg
        errMsg: '不可操作其他机构的成员'

    tmpResult.classe.students.addToSet tmpResult.student._id
    do tmpResult.classe.saveQ
  .then (result) ->
    res.send result[0]
  .catch next
  .done()
