'use strict'

angular.module('budweiserApp').filter 'scheduleSummary', ->
  weekdays = ['周一','周二','周三','周四','周五','周六','周日']
  (schedules)->
    if schedules?.length
      summary = ''
      schedules.forEach (schedule)->
        summary += if moment(schedule.end).isSame(moment(schedule.until),'day') then moment(schedule.start).format('M月D日') else "每#{weekdays[moment(schedule.start).isoWeekday()-1]}"
        summary += moment(schedule.start).format('HH:mm')
        summary += '-'
        summary += moment(schedule.end).format('HH:mm')
        summary += ', '
      summary = summary.substr(0,summary.length-2) + '。'
      summary
    else
      '无具体上课时间'
