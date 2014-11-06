"use strict"

mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Organization = BaseModel.subclass
  classname: 'Organization'
  initialize: ($super) ->
    @schema = new Schema
      uniqueName:
        type : String
        required : true
        unique : true
      name:
        type: String
        required: true
      isPro:
        type: Boolean
        required: true
        default: false
      type:
        type: String
        required : true
      logo: String
      description : String # url
      paid : 
        type : Boolean
        default : false

    $super()

  findBy: (uniqueName) ->
    @findOneQ uniqueName: uniqueName
