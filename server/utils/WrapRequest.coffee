require '../common/init'
AdapterUtils = _u.getUtils 'adapter'

class WrapRequest
  constructor: (@Model) ->

  buildConditions: (query) ->
    conditions = {}
    conditions.courseId = query.courseId if query.courseId

    conditions.deleteFlag = {$ne: true}

    return conditions


  populateQuery: (mongoQuery, options = []) ->
    for option in options
      mongoQuery = mongoQuery.populate option

    return mongoQuery

  # 因为doc的populate对象没有execQ方法，所以必须在最后一步调用populateQ方法
  # 所以出此下策，若有更好的方法，请重构此函数
  populateDoc: (mongoDoc, options = []) ->
    for option, i in options
      if i is options.length - 1
        return mongoDoc.populateQ option
      else
        mongoDoc = mongoDoc.populate option
    logger.error '正常情况，永远不会执行到这行代码'


  wrapPageIndex: (req, res, next, conditions, options = {}) ->
    logger.info 'page index conditions:', conditions
    logger.info 'page index options:', options

    # 若有sort参数传递，则解析结果，否则直接使用默认排序{created: -1}
    if options.sort?
      try
        options.sort = JSON.parse(options.sort)
      catch err
        logger.error err
        options.sort = null

    mongoQuery = @Model.find conditions
      .sort options.sort ? {created: -1}
      .limit ~~options.limit ? Const.PageSize[@constructor.name]
      .skip ~~options.from

    mongoQuery = @populateQuery mongoQuery, @Model.populates?.index

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


  wrapIndex: (req, res, next, conditions) ->
    conditions.deleteFlag = {$ne: true}
    logger.info 'index conditions:', conditions

    mongoQuery = @Model.find conditions
    mongoQuery = @populateQuery mongoQuery, @Model.populates?.index

    mongoQuery.execQ()
    .then (docs) ->
      res.send docs
    .catch next
    .done()


  wrapShow: (req, res, next, conditions, update) ->
    logger.info 'show conditions:', conditions
    mongoQuery = (
      if _.isEmpty update
        @Model.findOne conditions
      else
        @Model.findOneAndUpdate conditions, update
    )
    mongoQuery = @populateQuery mongoQuery, @Model.populates?.show

    mongoQuery.execQ()
    .then (doc) ->
      res.send doc
    .catch next
    .done()


  wrapCreate: (req, res, next, data) ->
    logger.info 'create data:', data
    @Model.createQ data
    .then (newDoc) =>
      @populateDoc newDoc, @Model.populates?.create
    .then (doc) ->
      res.send doc
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


  wrapDestroy: (req, res, next, conditions) ->
    logger.info 'destroy conditions:', conditions

    (if @Model.schema.paths.deleteFlag
      @Model.updateQ conditions, {deleteFlag: true}
    else
      @Model.removeQ conditions
    ).then () ->
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
