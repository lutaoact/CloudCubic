jade = require 'jade'
fs = require('fs')
querystring = require("querystring");
nodemailer = require('nodemailer');
scTransport = require('./sendcloud-transport');

pwdResetTpl = require('fs').readFileSync(__dirname + '/views/pwdReset.jade', 'utf8')
pwdResetFn = jade.compile pwdResetTpl, pretty: true

pwdActivationTpl = require('fs').readFileSync(__dirname + '/views/pwdActivation.jade', 'utf8')
pwdActivationFn = jade.compile pwdActivationTpl, pretty: true

config = require '../../config/environment'
emailConfig = config.emailConfig
transporter = nodemailer.createTransport(scTransport(emailConfig))


sendMail = (receiverEmail, htmlOutput, subject, orgName) ->
  mailOptions =
    from: orgName+" <noreply@cloud3edu.cn>"
    to: receiverEmail
    subject: subject
    html: htmlOutput

  transporter.sendMail mailOptions, (error, info) ->
    console.log(error || 'Message sent: ' + info)


exports.sendPwdResetMail = (receiverName, receiverEmail, host, token, orgName) ->
  if(orgName == null || orgName == undefined)
    orgName = "学之方"

  locals =
    username: receiverName
    resetLink: host + '/reset?email='+receiverEmail+'&token='+token
    orgName: orgName
    host: host

  htmlOutput = pwdResetFn locals

  console.log htmlOutput

  sendMail receiverEmail, htmlOutput, orgName+" -- 密码找回邮件", orgName


exports.sendActivationMail = (receiverEmail, activationCode, host, orgName) ->
  if(orgName == null || orgName == undefined)
    orgName = "学之方"

  activationLinkQS = querystring.stringify
    email: receiverEmail
    activation_code: activationCode
    orgName: orgName
    host: host

  activation_link = host+'/api/users/completeActivation?'+ activationLinkQS
  locals =
    email: receiverEmail
    activation_link: activation_link

  htmlOutput = pwdActivationFn locals

  sendMail receiverEmail, htmlOutput, orgName+" -- 账户激活邮件", orgName
