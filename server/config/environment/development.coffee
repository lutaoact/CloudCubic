'use strict'

# Development specific configuration
# ==================================
module.exports =
  host: 'http://localhost:9000'

  wechatToken: 'woaixuezhifang'

  # MongoDB connection options
  mongo:
    uri: 'mongodb://localhost/budweiser-dev'

  logger:
    path: '/data/log/budweiser.log'
    level: 'DEBUG'

  local:
    tempDir : '/temp_node_dir'

  nodejsServer : '115.29.244.232'

  weixinAuthCallbackURL: '/auth/weixin/callback'

  weiboAuth:
    appkey: '1324448620'
    secret: '3bb9527da4c087f942c7e785ddc5332a'
    oauth_callback_url: 'http://www.cloud3edu.cn/auth/weibo/callback'

  qqAuth:
    appkey: '101170221'
    secret: 'd847467b7087385fc73afa150cd82911'
    oauth_callback_url: 'http://www.cloud3edu.cn/auth/qq/callback'

  redis :
    port : 6379
    host : "localhost"

# Qiniu access_key and secret_key
  qiniu:
    access_key : '_NXt69baB3oKUcLaHfgV5Li-W_LQ-lhJPhavHIc_'
    secret_key  : 'qpIv4pTwAQzpZk6y5iAq14Png4fmpYAMsdevIzlv'
    signed_url_expires : 24 * 60 * 60

  s3:
    accessKeyId : 'AKIAOQO4QDXGFY3APFBQ'
    secretAccessKey : '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'
    region : 'cn-north-1'
    algorithm : 'AWS4-HMAC-SHA256'

  azure:
    acsBaseAddress: "https://wamsprodglobal001acs.accesscontrol.chinacloudapi.cn/v2/OAuth2-13"
#    shaAPIServerAddress: 'https://wamsshaclus001rest-hs.chinacloudapp.cn/API/'
#    bjbAPIServerAddress: 'https://wamsbjbclus001rest-hs.chinacloudapp.cn/API/'
    serverAddress: 'https://wamsbjbclus001rest-hs.chinacloudapp.cn/API/'
    signed_url_expires : 24 * 60 # in minutes
    defaultHeaders : (access_token)->
      Accept: 'application/json;odata=verbose'
      DataServiceVersion: '3.0'
      MaxDataServiceVersion: '3.0'
      'x-ms-version': '2.5'
      'Content-Type': 'application/json;odata=verbose'
      Authorization: 'Bearer '+access_token

  assetHost :
    uploadImageType : '0'
    uploadSlideType : '1'
    uploadVideoType : '3'
    uploadFileType : '0'

  assetsConfig:
    0:
      serviceName: 'qiniu'
      domain : 'temp-cloud3edu-com.qiniudn.com'
      bucket_name : 'temp-cloud3edu-com'
    1:
      serviceName: 's3'
      slideBucket : 'slides.cloud3edu.cn'
      slideUploadBucket: 'temp.cloud3edu.cn'
    2:
      serviceName: 'azure'
      accountName: 'trymedia'
      accountKey: 'HQVc3/yjrl8QDw7/NKvnbG2/jFmN7mJ++75xunlVD+M='
    3:
      serviceName: 'azure'
      accountName: 'cloud3educnmedia'
      accountKey: '4N+9pgfuQnlo2qYj3OpwvS0TopFStMpx139zsORMc3k='

  emailConfig:
    auth:
      api_user: 'cloud3edu'
      api_key: 'gXI2WTs8w4D6BF09'

  baiduPushService:
    ak: "d3ylollIsSvgrAKss9iD9pGt"           # API Key
    sk: "XTxRVe6SvXnx0N3CdOSu5j1swXcEoHi2"   # Secret Key

  videoViewTimeLimit: 50
