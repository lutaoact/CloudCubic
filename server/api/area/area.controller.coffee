"use strict"

chineseCities = require 'chinese-cities'

exports.index = (req, res, next) ->
  res.send chineseCities.data
