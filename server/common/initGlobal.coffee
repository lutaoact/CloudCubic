global._  = require 'lodash'
global._s = require 'underscore.string'
global.socketMap = {}
global.demoUserCount = 0
global._u = require './util'
global.ErrCode = require './ErrCode'

process.env.NODE_ENV = process.env.NODE_ENV || 'development'
global.config = require '../config/environment'
global.logger = require('./logger').logger
global.loggerD = require('./logger').loggerD
global.loggerC = require('./logger').loggerC
global.Q = require 'q'
global.Const = require './Const'
