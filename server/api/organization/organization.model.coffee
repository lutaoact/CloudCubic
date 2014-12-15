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
        type: String
        unique: true

    $super()

  findBy: (uniqueName) ->
    @findOneQ uniqueName: uniqueName
