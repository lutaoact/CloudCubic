
#
# * Push API wrapper
# *
#

util = require("util")
assert = require("assert")
crypto = require("crypto")
http = require("http")
querystring = require("querystring")
PROTOCOL_SCHEMA = "http://"
SERVER_HOST = "channel.api.duapp.com"
COMMON_PATH = "/rest/2.0/channel/"
#URL_HEADER = PROTOCOL_SCHEMA + SERVER_HOST;
debug = true
errMsg =
  INVALID_ARGS: "Arguments error"
  INVALID_USER_ID: "Arguments error: invalid user_id, the length of user_id must be less than 257B"
  INVALID_START: "Arguments error: invalid start, start must be equal or greater than 0 "
  INVALID_LIMIT: "Arguments error: invalid limit, limit must be greater than 0 "
  INVALID_CHANNEL_ID: "Arguments error: invalid channel_id, type of value must be String"
  INVALID_MESSAGES: "Arguments error: invalid messages type of messages must be String"
  INVALID_TAG: "Arguments error: invalid tag, the length of tag must be less than 129B"
  INVALID_PUSH_TYPE: "Arguments error: invalid push_type, type of push_type is 1, 2 or 3"
  INVALID_DEVICE_TYPE: "Arguments error: invalid device_type, type of device_type is 1, 2, 3, 4 or 5"
  INVALID_MESSAGE_TYPE: "Arguments error: invalid message_type, type of message_type is 0 or 1"
  INVALID_MSG_KEYS: "Arguments error: invalid msg_keys, type of messages must be String"
  INVALID_MESSAGE_EXPIRES: "Arguments error: invalid message_expires, message_expires must be equal or greater than 0 "

#
# * error message
#

#
# * To encode url
# * @param {String} str Body string
# * @returns {String} encoded url
# * @desc php urlencode is different from js, the way of Push server encode is same with php, so js need do some change
#
urlencode = (str) ->

  # http://kevin.vanzonneveld.net
  str = (str + "").toString()

  # Tilde should be allowed unescaped in future versions of PHP (as reflected below), but if you want to reflect current
  # PHP behavior, you would need to add ".replace(/~/g, '%7E');" to the following.
  encodeURIComponent(str).replace(/!/g, "%21").replace(/'/g, "%27").replace(/\(/g, "%28").replace(/\)/g, "%29").replace(/\*/g, "%2A").replace /%20/g, "+"

#
# * Get current time
# * @returns {Number} The current time in seconds since the Epoch
#
getTimestamp = ->
  timestamp = Math.floor(new Date().getTime() / 1000)
  timestamp

#
# * Sort Obj with abc
#
sortObj = (obj) ->
  index = []
  tmpObj = {}
  for i of obj
    index.push i  if obj.hasOwnProperty(i)
  index.sort()
  i = 0
  while i < index.length
    tmpObj[index[i]] = obj[index[i]]
    i++
  tmpObj

#
# * Generate sign
# * @see http://developer.baidu.com/wiki/index.php?title=docs/cplat/mq/sign
# * @param {String} method HTTP request method
# * @param {String} url HTTP request url
# * @param {Object} params HTTP request body
# * @param {String} sk User's secret key in bae
# * @returns {String} sign
#
getSign = (method, url, params, sk) ->
  baseStr = method + url
  for i of params
    baseStr += i + "=" + params[i]
  baseStr += sk

  #var encodeStr = encodeURIComponent(baseStr);
  encodeStr = urlencode(baseStr)
  console.log "getSign: base str = " + baseStr + ", encode str = " + encodeStr  if debug
  md5sum = crypto.createHash("md5")
  md5sum.update encodeStr
  sign = md5sum.digest("hex")
  sign

#
# * Common Push request
# * @param {Object} bodyArgs
# * @param {String} path Url path
# * @param {String} sk User's secret key in bae
# * @param {function} cb cb(err, result)
#
request = (bodyArgs, path, sk, id, host, cb) ->
  assert.ok bodyArgs.method
  assert.ok path
  assert.ok sk
  bodyArgs.sign = getSign("POST", PROTOCOL_SCHEMA + host + path, bodyArgs, sk)
  bodyArgsArray = []
  for i of bodyArgs
    bodyArgsArray.push i + "=" + urlencode(bodyArgs[i])  if bodyArgs.hasOwnProperty(i)
  bodyStr = bodyArgsArray.join("&")

  #var bodyStr = querystring.stringify(bodyArgs);
  console.log "body length = " + bodyStr.length + ", body str = " + bodyStr  if debug
  options =
    host: host
    method: "POST"
    path: path
    headers:
      "Content-Length": bodyStr.length
      "Content-Type": "application/x-www-form-urlencoded"

  req = http.request(options, (res) ->
    if debug
      console.log "status = " + res.statusCode
      console.log "res header = "
      console.dir res.headers
    resBody = ""
    res.on "data", (chunk) ->
      resBody += chunk
      return

    res.on "end", ->
      console.log "res body: " + resBody  if debug

      #var jsonObj = JSON.parse(resBody);
      try
        jsonObj = JSON.parse(resBody)
      catch e
        cb and cb(e)
        return
      errObj = null
      id.request_id = jsonObj["request_id"]
      unless res.statusCode is 200
        error_code = "Unknown"
        error_code = jsonObj["error_code"]  if jsonObj["error_code"] isnt `undefined`
        error_msg = "Unknown"
        error_msg = jsonObj["error_msg"]  if jsonObj["error_msg"] isnt `undefined`
        request_id = "Unknown"
        request_id = jsonObj["request_id"]  if jsonObj["error_msg"] isnt `undefined`
        errObj = new Error("Push error code: " + error_code + ", error msg: " + error_msg + ", request id: " + request_id)
      cb errObj, jsonObj
      return

    return
  )
  req.on "error", (e) ->
    console.log "error : " + util.inspect(e)  if debug
    cb e, null
    return

  req.write bodyStr
  req.end()
  return

#
# * Check options
# * @param {Object} options
# * @param {Array} must Properties are must in options
#
checkOptions = (options, must) ->
  checkType = (type, condition) ->
    i = 0

    while i < condition.length
      return true  if type is condition[i]
      i++
    false

  must.forEach (ele) ->
    unless options.hasOwnProperty(ele)
      err = errMsg.INVALID_ARGS + ": " + ele + " is must"
      throw new Error(err)
    return

  throw new Error(errMsg.INVALID_USER_ID)  if options["user_id"] and not (typeof options["user_id"] is "string" and options["user_id"].length <= 256)
  throw new Error(errMsg.INVALID_START)  if options["start"] and not (typeof options["start"] is "number" and options["start"] >= 0)
  throw new Error(errMsg.INVALID_LIMIT)  if options["limit"] and not (typeof options["limit"] is "number" and options["limit"] > 0)
  throw new Error(errMsg.INVALID_CHANNEL_ID)  if options["channel_id"] and (typeof options["channel_id"] isnt "string")
  throw new Error(errMsg.INVALID_PUSH_TYPE)  if options["push_type"] and not (typeof options["push_type"] is "number" and checkType(options["push_type"], [
    1
    2
    3
  ]))
  throw new Error(errMsg.INVALID_DEVICE_TYPE)  if options["device_type"] and not (typeof options["device_type"] is "number" and checkType(options["device_type"], [
    1
    2
    3
    4
    5
  ]))
  throw new Error(errMsg.INVALID_MESSAGE_TYPE)  if options["message_type"] and not (typeof options["message_type"] is "number" and checkType(options["message_type"], [
    0
    1
  ]))
  throw new Error(errMsg.INVALID_TAG)  if options["tag"] and not (typeof options["tag"] is "string" and options["tag"].length <= 128)
  throw new Error(errMsg.INVALID_MESSAGES)  if options["messages"] and (typeof options["messages"] isnt "string")
  throw new Error(errMsg.INVALID_MSG_KEYS)  if options["msg_keys"] and (typeof options["msg_keys"] isnt "string")
  throw new Error(errMsg.INVALID_MESSAGE_EXPIRES)  if options["message_expires"] and (typeof options["message_expires"] isnt "string")
  return

#
# * @name Push
# * @constructor
# * @param {Object} options Set ak/sk/host
# * @param {String} [options.ak] User API key
# * @param {String} [options.sk] User secret key
# * @param {String} [options.host] TaskQueue server host
#
Push = (options) ->
  self = this
  opt =
    ak: process.env.BAE_ENV_AK
    sk: process.env.BAE_ENV_SK
    host: process.env.BAE_ENV_ADDR_CHANNEL or SERVER_HOST

  if options
    for i of options
      if options.hasOwnProperty(i)
        if typeof options[i] is "string"
          opt[i] = options[i]
        else
          throw new Error("Invalid ak, sk, or counter host")
  self.ak = opt.ak
  self.sk = opt.sk
  self.host = opt.host
  self.request_id = null
  return

#
# * Query user binding list
# * @param {Object} options
# * @param {String} options.user_id User id, the length of user_id must be less than 257B
# * @param {Number} [options.device_type] Device type
# * @param {Number} [options.start] Start postion, default value is 0
# * @param {Number} [options.limit] Numbers of lists, default value is 10
# * @param {function} cb(err, result)
#
Push::queryBindList = (options, cb) ->
  self = this
  opt = {}
  if typeof options is "function" and arguments_.length is 1
    cb = options
    options = {}
  options = {}  unless options
  for i of options
    opt[i] = options[i]  if options.hasOwnProperty(i)
  checkOptions opt, ["user_id"]
  path = COMMON_PATH + (options["channel_id"] or "channel")
  opt["method"] = "query_bindlist"
  opt["apikey"] = self.ak
  opt["timestamp"] = getTimestamp()
  opt = sortObj(opt)
  wrap_id = request_id: null
  request opt, path, self.sk, wrap_id, self.host, (err, result) ->
    self.request_id = wrap_id.request_id
    if err
      cb and cb(err)
      return
    cb and cb(null, result)
    return

  return


#
# * Push message
# * @param {Object} options
# * @param {Number} options.push_type Push type
# * @param {String} options.messages Message list
# * @param {String} options.msg_keys
# * @param {String} [options.user_id]
# * @param {String} [options.tag]
# * @param {Number} [options.channel_id]
# * @param {Number} [options.device_type] Device type
# * @param {Number} [options.message_type]
# * @param {Number} [options.message_expires]
# * @param {function} cb(err, result)
#
Push::pushMsg = (options, cb) ->
  self = this
  opt = {}
  if typeof options is "function" and arguments_.length is 1
    cb = options
    options = {}
  options = {}  unless options
  for i of options
    opt[i] = options[i]  if options.hasOwnProperty(i)
  must = [
    "push_type"
    "messages"
    "msg_keys"
  ]
  if opt["push_type"] is 1
    must.push "user_id"
  else if opt["push_type"] is 2
    must.push "tag"
  else

  checkOptions opt, must
  path = COMMON_PATH + "channel"
  opt["method"] = "push_msg"
  opt["apikey"] = self.ak
  opt["timestamp"] = getTimestamp()
  opt = sortObj(opt)
  wrap_id = request_id: null
  request opt, path, self.sk, wrap_id, self.host, (err, result) ->
    self.request_id = wrap_id.request_id
    if err
      cb and cb(err)
      return
    cb and cb(null, result)
    return

  return

module.exports = Push
