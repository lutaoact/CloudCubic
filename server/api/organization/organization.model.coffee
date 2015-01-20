"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Organization = BaseModel.subclass
  classname: 'Organization'
  initialize: ($super) ->
    @schema = new Schema
      uniqueName: #subdomain in cloud3edu
        type : String
        required : true
        unique : true
      name:
        type: String
        required: true
      type:
        type: Number
        required : true
      logo: String
      description : String # url
      location:
        name: String
        id: String
      paid:
        type : Boolean
        default : false
      customDomain:
        type : String
        unique : true
      telephone:
        type : String
      banners: [
        {
          image: String
          text: String
        }
      ]
      icp: String
      copyright: String
      about: String

    setupOrgSchema @schema

    $super()

  findByUniqueName: (uniqueName) ->
    @findOneQ uniqueName: uniqueName

  findByCustomDomain: (customDomain) ->
    @findOneQ customDomain: customDomain

setupOrgSchema = (OrgSchema) ->

  OrgSchema
  .path 'uniqueName'

  # 验证唯一标识不重复
  .validate (value, respond) ->
    self = this
    this.constructor.findOne
      uniqueName: value
    , (err, org) ->
      throw err if err
      notTaken = !org or org.id == self.id
      respond notTaken
  , '该机构唯一标识已经被占用，请选择其他标识'

  # 验证唯一标识为合法字符
  .validate (value) ->
    /^\w[\w.-]+\w$/i.test(value)
  , """该机构标识不合法，请使用字母、数字、点（.）或者横线（-），不少于3个字符"""

  # 验证系统保留字段
  .validate (value) ->
    value = value.toLowerCase()
    console.log 'validate...', value
    [ 'www'
      'api'
      'css'
      'dns'
      'cdn'
      'app'
      'bbs'
      'cdn'
      'data'
      'test'
      'blog'
      'admin'
      'email'
      'smtp'
      'pop'
      'pop3'
      'feed'
      'image'
      'images'
      'video'
      'videos'
      'search'
      'static'
      'statics'
      'public'
      'private'
      'upload'
      'down'
      'download'
    ].indexOf(value) is -1
  , '该机构唯一标识为系统保留字段，请选择其他标识'


  OrgSchema
  .path 'customDomain'
  .validate (value) ->
    return value.indexOf('cloud3edu') is -1
  , '域名中不允许带有cloud3edu'
  .validate (value, respond) ->
    self = this
    this.constructor.findOne
      customDomain: value
    , (err, org) ->
      throw err if err
      notTaken = !org or org.id == self.id
      respond notTaken
  , '该自定义域名已经被占用，请选择其他域名'
