ActiveTime = _u.getModel 'active_time'
WrapRequest = new (require '../../utils/WrapRequest')(ActiveTime)

exports.index = (req, res, next) ->
  conditions =
    orgId: req.user.orgId
    $gte : new Date(req.query.from)
    $lte : new Date(req.query.to)

  WrapRequest.wrapIndex req, res, next, conditions
