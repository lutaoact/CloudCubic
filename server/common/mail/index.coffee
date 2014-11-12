jade = require 'jade'
fs = require('fs')
querystring = require("querystring");
nodemailer = require('nodemailer');

pwdResetTpl = require('fs').readFileSync(__dirname + '/views/pwdReset.jade', 'utf8')
pwdResetFn = jade.compile pwdResetTpl, pretty: true

pwdActivationTpl = require('fs').readFileSync(__dirname + '/views/pwdActivation.jade', 'utf8')
pwdActivationFn = jade.compile pwdActivationTpl, pretty: true

config = require '../../config/environment'
host = config.host

emailConfig = config.emailConfig
transporter = nodemailer.createTransport emailConfig

exports.sendPwdResetMail = (receiverName, receiverEmail, resetLink) ->
  locals =
    username: receiverName
    resetLink: resetLink

  htmlOutput = pwdResetFn locals

  mailOptions =
    from: "学之方" + ' <' + emailConfig.auth.user + '>'
    to: receiverEmail
    subject: "学之方 -- 找回密码邮件"
    html: htmlOutput

  transporter.sendMail mailOptions, (error, info) ->
    console.log(error || 'Message sent: ' + info.response)


exports.sendActivationMail = (receiverEmail, activationCode) ->
  activationLinkQS = querystring.stringify
    email: receiverEmail
    activation_code: activationCode

  activation_link = host+'/api/users/completeActivation?'+ activationLinkQS
  locals =
    email: receiverEmail
    activation_link: activation_link

  htmlOutput = pwdActivationFn locals

  mailOptions =
    from: "学之方" + ' <' + emailConfig.auth.user + '>'
    to: receiverEmail
    subject: "学之方 -- 激活邮件"
    html: htmlOutput

  transporter.sendMail mailOptions, (error, info) ->
    console.log(error || 'Message sent: ' + info.response)
