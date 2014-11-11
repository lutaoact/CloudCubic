jade = require 'jade'
fs = require('fs')
querystring = require("querystring");

pwdResetTpl = require('fs').readFileSync(__dirname + '/views/pwdReset.jade', 'utf8')
pwdResetFn = jade.compile pwdResetTpl, pretty: true

pwdActivationTpl = require('fs').readFileSync(__dirname + '/views/pwdActivation.jade', 'utf8')
pwdActivationFn = jade.compile pwdActivationTpl, pretty: true

emailjs = require 'emailjs/email'

config = require '../../config/environment'
credentials = config.emailCredentials
host = config.host


exports.sendPwdResetMail = (receiverName, receiverEmail, resetLink) ->
  locals =
    username: receiverName
    resetLink: resetLink

  htmlOutput = pwdResetFn locals

  message =
    from: "学之方" + ' <' + credentials.user + '>'
    to: receiverEmail
    subject: "学之方 -- 找回密码邮件"
    attachment: [{data: htmlOutput, alternative:true}]

  server = emailjs.server.connect credentials
  server.send message, (err, message) ->
    console.log(err || message)


exports.sendActivationMail = (receiverEmail, activationCode) ->
  activationLinkQS = querystring.stringify
    email: receiverEmail
    activation_code: activationCode

  activation_link = host+'/api/users/completeActivation?'+ activationLinkQS
  locals =
    email: receiverEmail
    activation_link: activation_link

  htmlOutput = pwdActivationFn locals

  message =
    from: "学之方" + ' <' + credentials.user + '>'
    to: receiverEmail
    subject: "学之方 -- 激活邮件"
    attachment: [{data: htmlOutput, alternative:true}]

  server = emailjs.server.connect credentials
  server.send message, (err, message) ->
    console.log(err || message)

