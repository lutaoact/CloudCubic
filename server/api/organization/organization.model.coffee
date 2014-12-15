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
      customDomain:
        type : String
        unique: true
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
        type: String
        unique: true

    setupOrgSchema @schema

    $super()

  findBy: (uniqueName) ->
    @findOneQ uniqueName: uniqueName


setupOrgSchema = (OrgSchema) ->

  OrgSchema
  .path 'uniqueName'
  .validate (value, respond) ->
    self = this
    this.constructor.findOne
      uniqueName: value
    , (err, org) ->
      throw err if err
      notTaken = !org or org.id == self.id
      respond notTaken
  , '该机构唯一标识已经被占用，请选择其他标识'


  OrgSchema
  .path 'customDomain'
  .validate (value, respond) ->
    self = this
    this.constructor.findOne
      customDomain: value
    , (err, org) ->
      throw err if err
      notTaken = !org or org.id == self.id
      respond notTaken
  , '该自定义域名已经被占用，请选择其他域名'
