BaseUtils = require '../../common/BaseUtils'
NoticeUtils = _u.getUtils 'notice'
SocketUtils = _u.getUtils 'socket'
DisTopic = _u.getModel 'dis_topic'

buildLikeCommentArgs = (comment) ->
  
  result = 
    data :
      commentId : comment._id
  
  switch comment.type
    when Const.CommentType.DisTopic
      result.type = Const.NoticeType.LikeTopicComment
      result.data.disTopicId = comment.belongTo
      
    when Const.CommentType.Course
      result.type = Const.NoticeType.LikeCourseComment
      result.data.courseId = comment.belongTo
      
    when Const.CommentType.Lecture
      result.type = Const.NoticeType.LikeLectureComment
      result.data.lectureId = comment.belongTo
      
    when Const.CommentType.Teacher
      console.log 'like comment for teacher...'
      #TODO: add like the comment for teacher
    
  return result
  
  
class LikeUtils extends BaseUtils
  createLike: (Model, objectId, userId) ->
    # we only want to send notice for like action, not for dislike action
    likeAction = false
    
    Model.findByIdQ objectId
    .then (object) ->
      if object.likeUsers.indexOf(userId) > -1
        object.likeUsers.pull userId
      else
        object.likeUsers.addToSet userId
        console.log "userId: #{userId} liked #{Model.constructor.name}: #{objectId}"
        likeAction = true
  
      do object.saveQ
    .then (result) ->
      result[0].likeAction = likeAction
      return result[0]
  
  # create and send notice based on Like's type
  sendLikeNotice : (Model, doc, fromWhom) ->
    targetName = Model.constructor.name
    console.log 'TargetName: ', targetName
    data = {}
    
    switch targetName
      when 'DisTopic'
        data.disTopicId = doc._id
        data.forumId = doc.forumId
        targetUserId = doc.postBy
        noticeType = Const.NoticeType.LikeTopic
        
      when 'Comment'  
        targetUserId = doc.postBy
        {noticeType, data} = buildLikeCommentArgs doc
      else
        logger.error 'Unknown Like type'
    
    NoticeUtils.addNotice targetUserId, fromWhom, noticeType, data 
    .then (notice) ->
      console.log 'Notice to send: ', notice
      SocketUtils.sendNotices notice
      
      # TODO: for mobile app
      #DeviceUtils.pushToUser notice

exports.LikeUtils = LikeUtils