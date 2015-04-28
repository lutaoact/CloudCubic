ActiveTime = _u.getModel 'active_time'
WrapRequest = new (require '../../utils/WrapRequest')(ActiveTime)

exports.index = (req, res, next) ->
  conditions =
    orgId: req.user.orgId
    date:
      $gte : new Date(req.query.from)
      $lte : new Date(req.query.to)
  conditions.userId = req.query.userId if req.query.userId
  WrapRequest.wrapIndex req, res, next, conditions
