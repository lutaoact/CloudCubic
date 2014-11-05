Organization = _u.getModel 'organization'

class OrganizationUtils
  check: (uniqueName) ->
    Organization.findBy uniqueName
    .then (org) ->
      if org?
        return Q.reject
          status : 400
          errCode : ErrCode.UniqueNameInUsed
          errMsg : 'uniqueName已被使用'


exports.OrganizationUtils = OrganizationUtils
