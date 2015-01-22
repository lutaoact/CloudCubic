AssetUtils = _u.getUtils 'asset'
config = require '../../config/environment'
redisClient = require '../../common/redisClient'
VideoViewCounter = _u.getModel 'video_view_counter'

retrieveAsset = (key, assetType) ->

  # check cache first
  redisClient.q.get key
  .then (cached) ->
    if cached? then return cached

    logger.info "No cache found for #{key}"
    logger.info 'Asset type ' + assetType
    switch config.assetsConfig[assetType].serviceName
      when 'qiniu'
        AssetUtils.getAssetFromQiniu key, assetType
      when 's3'
        AssetUtils.getAssetFromS3 key, assetType
      when 'azure'
        AssetUtils.getAssetFromAzure key, assetType
      else
        throw new Error('asset host not found')


uploadAsset = (assetType, fileName) ->
  switch config.assetsConfig[assetType].serviceName
    when 'qiniu'
      console.log 'upload host is qiniu'
      AssetUtils.genQiniuUpParams assetType, fileName
    when 's3'
      console.log 'upload host is S3'
      AssetUtils.genS3UpParams assetType, fileName
    when 'azure'
      console.log 'upload host is Azure'
      AssetUtils.genAzureUpParams assetType, fileName
    else
      throw new Error("Asset host #{assetHost} not found")

###
  redirect api/assets/images/key to asset host URL
###

makeGetFunc = (type) ->
  return (req, res, next) ->
    logger.info "req.url: #{req.url}"
    regex = new RegExp('/' + type + 's/\\d+/')
    key = decodeURI(req.url.replace(regex, ''))
    assetType = req.params.assetType

    startQ = Q()
    # for video view time limit:
#    if ((req.user?) && (type=='video') && (req.headers.range.substring(0,8)=='bytes=0-'))
#      startQ = VideoViewCounter.updateQ
#        userId: req.user._id
#        mediaKey: key
#        counter: {"$lt": config.videoViewTimeLimit}
#      ,
#        $inc:
#          counter: 1
#      ,
#        upsert: true
#      .fail (err)->
#        if err.code == 11000
#          Q.reject
#            status: 400
#            errCode: ErrCode.ReachVideoViewTimeLimit
#            errMsg: '超过播放次数上限'
#        else
#          throw err

    startQ
    .then ()->
      retrieveAsset key, assetType
    .then (downloadUrl)->
      res.redirect downloadUrl
    .catch next
    .done()

makeUploadFunc = (type) ->
  ucfirst = _s.capitalize type
  return (req, res, next) ->
    uploadType = config.assetHost["upload#{ucfirst}Type"]

    uploadAsset uploadType, req.query.fileName
    .then (data)->
      data.prefix = "/api/assets/#{type}s/#{uploadType}/"
      res.send data
    .catch next
    .done()

exports.getImages = makeGetFunc 'image'
exports.getVideos = makeGetFunc 'video'
exports.getSlides = makeGetFunc 'slide'
exports.uploadImage = makeUploadFunc 'image'
exports.uploadVideo = makeUploadFunc 'video'
exports.uploadSlide = makeUploadFunc 'slide'
