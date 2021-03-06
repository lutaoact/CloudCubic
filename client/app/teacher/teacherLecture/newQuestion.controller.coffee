angular.module('budweiserApp').controller 'NewQuestionCtrl', (
  $scope
  $timeout
  keyPoints
  categoryId
  $modalInstance
  configs
) ->
  angular.extend $scope,
    imageSizeLimitation: configs.imageSizeLimitation
    keyPoints: keyPoints
    selectedKeyPoints:[]
    categoryId: categoryId._id||categoryId
    images: []
    question:
      body: ''
      detailSolution: ''
      categoryId: categoryId._id||categoryId
      choices: [{},{}]

    addKeyPoint: (keyPoint, input) ->
      if keyPoint?
        $scope.selectedKeyPoints.push angular.copy(keyPoint)
        return
      if input?
        keyPoints.post
          name: input
          categoryId: categoryId._id||categoryId
        .then (keyPoint) ->
          keyPoints.push keyPoint
          $scope.selectedKeyPoints.push angular.copy(keyPoint)
    removekeyPoint: (index) ->
      $scope.selectedKeyPoints.splice(index, 1)
    validateOptions: ->
      _.find($scope.question.choices, correct:true)?
    addOption: ->
      $scope.question.choices.push {}
    removeOption: (index) ->
      choices = $scope.question.choices
      choices.splice(index, 1)
      choices.push {} if choices.length == 0
    cancel: ->
      $modalInstance.dismiss('cancel')
    save: (question, form) ->
      unless form.$valid then return
      question.keyPoints = _.pluck($scope.selectedKeyPoints, '_id')
      question.body += _.reduce $scope.images, (result, image) ->
        result += """<img src='#{image}' class='question-image'>"""
        result
      , ''
      $modalInstance.close(question)

    onImageUploaded: (key) ->
      $scope.images.push key
