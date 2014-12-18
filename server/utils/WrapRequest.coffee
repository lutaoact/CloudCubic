require '../common/init'
AdapterUtils = _u.getUtils 'adapter'

class WrapRequest
  constructor: (@Model) ->

  buildConditions: (query) ->
    conditions = {}
    conditions.courseId = query.courseId if query.courseId

    conditions.deleteFlag = {$ne: true}

    return conditions


  wrapPageIndex: (req, res, next, conditions, options = {}) ->
    mongoQuery = @Model.find conditions
      .sort created: -1
      .limit options.limit ? Const.PageSize[@constructor.name]
      .skip options.from

    Q.all [
      mongoQuery.execQ()
      @Model.countQ conditions
    ]
    .then (data) ->
      res.send
        results: data[0]
        count: data[1]
    .catch next
    .done()


  wrapIndex: () ->
    return (req, res, next) =>
      conditions = @buildConditions req.query
      logger.info "index conditions:", conditions

      @Model.findQ conditions
      .then (docs) ->
        res.send docs
      .catch next
      .done()

  wrapOrgIndex: () ->
    return (req, res, next) =>
      conditions = @buildConditions req.query
      conditions.orgId = req.org?._id

      logger.info "org index conditions:", conditions

      @Model.findQ conditions
      .then (docs) ->
        res.send docs
      .catch next
      .done()

#  wrapIndex: () ->
#    return (req, res, next) =>
#      conditions = AdapterUtils.buildConditions req.query
#      options =
#        from : ~~req.query.from #from参数转为整数
#        limit: ~~req.query.limit
#
#      AdapterUtils.getCountAndPageInfo @Model, conditions, options
#      .then (data) ->
#        res.send
#          results: data[0]
#          count: data[1]
#      .catch next
#      .done()
#
  wrapShow: () ->
    return (req, res, next) =>
      _id = req.params.id

      @Model.findById _id
      .execQ()
      .then (doc) ->
        res.send doc
      .catch next
      .done()

  wrapOrgShow: () ->
    return (req, res, next) =>
      _id = req.params.id

      @Model.findOne _id: _id, orgId: req.org?._id
      .execQ()
      .then (doc) ->
        res.send doc
      .catch next
      .done()
#  wrapCommonShow: () ->
#    return (req, res, next) =>
#      _id = req.params.id
#
#      modelName = @Model.constructor.name
#      @Model.findById _id
#      .populate fieldMap[modelName].field, fieldMap[modelName].populate
#      .execQ()
#      .then (doc) ->
#        res.send doc
#      .catch next
#      .done()
#
#  wrapShow: () ->
#    return (req, res, next) =>
#      _id = req.params.id
#
#      modelName = @Model.constructor.name
#      @Model.findByIdQ _id
#      .then (doc) ->
#        doc.viewersNum += 1 #每次调用API，相当于查看一次
#        do doc.saveQ
#      .then (result) ->
#        result[0].populateQ fieldMap[modelName].field, fieldMap[modelName].populate
#      .then (doc) ->
#        res.send doc
#      .catch next
#      .done()
#
#  wrapCreate: (pickedKeys) ->
#    return (req, res, next) =>
#      data = _.pick req.body, pickedKeys
#      data[fieldMap[@Model.constructor.name].field] = req.user._id
#
#      @Model.createQ data
#      .then (newDoc) ->
#        res.send newDoc
#      .catch next
#      .done()

  wrapOrgCreate: (pickedKeys) ->
    return (req, res, next) =>
      data = _.pick req.body, pickedKeys
      data.orgId = req.user.orgId
      logger.info "create data:", data

      @Model.createQ data
      .then (newDoc) ->
        res.send 201, newDoc
      .catch next
      .done()


  wrapUpdate: (pickedUpdatedKeys) ->
    return (req, res, next) =>
      _id = req.params.id
      user = req.user

      #拣选出允许更新的字段
      data = _.pick req.body, pickedUpdatedKeys

      modelName = @Model.constructor.name
      @Model.getByIdAndUser _id, user._id
      .then (doc) ->
        updated = _.extend doc, data
        do updated.saveQ
      .then (result) ->
        result[0].populateQ fieldMap[modelName].field, fieldMap[modelName].populate
      .then (doc) ->
        res.send doc
      .catch next
      .done()

  wrapOrgDestroy: () ->
    return (req, res, next) =>
      _id = req.params.id
      @Model.updateQ {_id: _id}, {deleteFlag: true}
      .then () ->
        res.send 204
      .catch next
      .done()

  wrapDestroy: () ->
    return (req, res, next) =>
      _id = req.params.id
      @Model.updateQ {_id: _id}, {deleteFlag: true}
      .then () ->
        res.send 204
      .catch next
      .done()

  wrapLike: () ->
    return (req, res, next) =>
      _id = req.params.id
      user = req.user
      AdapterUtils.like @Model, _id, user._id
      .then (doc) ->
        res.send doc
      .catch next
      .done()


module.exports = WrapRequest
