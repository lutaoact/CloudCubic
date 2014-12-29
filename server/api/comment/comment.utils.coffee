BaseUtils = require('../../common/BaseUtils')

class CommentUtils extends BaseUtils
  getCommentRefByType: (type) ->
    return _u.getModel Const.CommentModelRef[type]

  # get all users this commet is targeted to. 
  # For discuss topic, it will be the author of topic
  # For course, it will be all course owners
  # For lecture, it will be lecture's course owners
  # For Teacher, it will be teacher himself
  getTargetUsers : (type, belongTo, commentBy) ->
    
    #console.log 'Enter getTargetUsers...'
    #console.log 'type is ', type
    #console.log 'type of type is ', typeof type
    #console.log 'belongTo is ', belongTo
    #console.log 'commentBy ', commentBy
    
    model = @getCommentRefByType type
    model.findByIdQ belongTo
    .then (obj) ->
      #console.log 'get obj', obj
      switch parseInt(type)
        when Const.CommentType.DisTopic 
          #console.log 'type distopic'
          return _.pull [obj.postBy], [commentBy]
          
        when Const.CommentType.Course
          #console.log 'type course'
          return _.pull obj.owners, [commentBy]
          
        when Const.CommentType.Lecture
          #todo: fixme
          return []
        when Const.CommentType.Teacher
          #todo: fixme
          return []
        else
          return []
    .catch (err) ->
      console.log err
    
          
      
exports.Instance = new CommentUtils()
exports.Class = CommentUtils
exports.CommentUtils = CommentUtils
