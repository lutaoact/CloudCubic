BaseUtils = require('../../common/BaseUtils')

class AdapterUtils extends BaseUtils

  buildConditions: (query) ->
    conditions = {}
    conditions.postBy = query.postBy if query.postBy
    conditions.creator = query.creator if query.creator
    conditions.type = query.type if query.type
    conditions.belongTo = query.belongTo if query.belongTo
    conditions.group = query.group if query.group

    return conditions

  getAllForPage: (Model, conditions, options) ->
    modelName = Model.constructor.name
    return Model.find((_.extend conditions, {deleteFlag: {$ne: true}}), '-deleteFlag')
    .sort created: -1
    .limit options.limit ? Const.PageSize[modelName]#Article or Course
    .skip options.from
    .populate fieldMap[modelName].field, fieldMap[modelName].populate
    .execQ()

  getCountAndPageInfo: (Model, conditions, from) ->
    return Q.all [
      @getAllForPage Model, conditions, from
      Model.countQ conditions
    ]

exports.AdapterUtils = AdapterUtils
