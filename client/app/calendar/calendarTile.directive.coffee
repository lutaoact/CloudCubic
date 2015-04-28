'use strict'

angular.module('budweiserApp').directive 'calendarTile', ($timeout)->
  templateUrl: 'app/calendar/calendar-tile.html'
  restrict: 'E'
  controller: 'CalendarTileCtrl'
