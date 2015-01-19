angular.module('budweiserApp')

.directive 'reports', ->
  restrict: 'EA'
  replace: true
  templateUrl: 'app/admin/organizationManager/reports.html'
  controller: 'ReportsCtrl'

.controller 'ReportsCtrl', (
  $scope
  $timeout
  Restangular
) ->
  angular.extend $scope,
    studentAnalyses: [
        name: '小王'
        days: 10
        duration: 3*360000
      ,
        name: '小黑'
        days: 20
        duration: 3.4*360000
    ]

    loading: true



