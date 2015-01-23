require '../server/common/init'
moment = require 'moment'

ActiveTime = _u.getModel 'active_time'

yesterday = moment().add(-1, 'days').format('YYYY-MM-DD')
yesterdayDate = new Date(yesterday)

jsonFile = require "/data/log/budweiser.data.log-#{yesterday}.json"
datas = []
for orgId, studentList of jsonFile
  for userId, stat of studentList
    datas.push
      orgId: orgId
      userId: userId
      date: yesterdayDate
      activeTime: stat.beat * Const.BeatTimeSpan + stat.me * Const.MeTimeSpan

console.log datas
ActiveTime.createQ datas
.then (results) ->
  console.log results
  process.exit 0
, (err) ->
  console.log err
  process.exit 1
