'use strict'

angular.module('budweiserApp').directive 'budEditor', ()->
  restrict: 'E'
  scope:
    row: '='
    content: '='
    editorName: '@'
    editorId: '@'
    onChange: '&'
  replace: true
  templateUrl: 'app/editor/bud-editor.html'

  link: (scope, element, attrs) ->

  controller: ($scope, $timeout, configs)->
    angular.extend $scope,
      imageSizeLimitation: configs.imageSizeLimitation
      onImgUploaded: (key)->
        $scope.metadata.images ?= []
        $scope.metadata.images.push
          url: "#{key}-blog"
          key: key

      removeImg: (image)->
        $scope.metadata.images.splice $scope.metadata.images.indexOf(image), 1

    $scope.$watch 'metadata', (value)->
      # should delay 2 seconds
      $scope.metadata ?= {}
      $scope.metadata.raw ?= ''
      $scope.content = $scope.metadata.raw.replace /\r?\n/g, '<br/>'
      $scope.metadata.images?.forEach (image)->
        $scope.content += "<img class=\"sm image-zoom\" src=\"#{image.url}\">"
      $scope.onChange?($text: $scope.content)
    , true

    $scope.$watch 'content', (value)->
      if !value
        $scope.metadata = {}
