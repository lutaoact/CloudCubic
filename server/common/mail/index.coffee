jade = require 'jade'
fs = require('fs')

pwdResetTpl = require('fs').readFileSync(__dirname + '/views/pwdReset.jade', 'utf8')
pwdResetFn = jade.compile pwdResetTpl, pretty: true

emailjs = require 'emailjs/email'

# TODO: move to config
credentials =
  user: 'noreply.cloud3edu@gmail.com'
  password:  'cloud3eduuuu'
  host: 'smtp.gmail.com'
  ssl: true
  timeout: 20000


exports.sendPwdResetMail = (senderName, receiverName, receiverEmail, resetLink) ->
  locals =
    senderName: senderName
    username: receiverName
    resetLink: resetLink

  htmlOutput = pwdResetFn locals

  message =
    from: senderName + ' <' + credentials.user + '>'
    to: receiverEmail
    subject: "password reset link"
    attachment: [{data: htmlOutput, alternative:true}]

  server = emailjs.server.connect credentials
  server.send message, (err, message) ->
    console.log(err || message)
