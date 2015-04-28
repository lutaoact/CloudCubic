'use strict'

angular.module('budweiserApp')

.directive 'editStudentTile', ->
  restrict: 'EA'
  replace: true
  controller: 'EditUserTileCtrl'
  templateUrl: 'app/admin/studentManager/editStudentTile.html'
  scope:
    user: '='
    canDelete: '@'
    infoEditable: '@'
    onUpdateUser: '&'
    onDeleteUser: '&'


