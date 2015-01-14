'use scrict'

angular.module('budweiserApp').controller 'loginModalCtrl', (
  org
  Auth
  $scope
  $state
  notify
  $modal
  $timeout
  Restangular
  $modalInstance
) ->

  checkEmailPromise = null

  angular.extend $scope,
    user: {}
    org: org
    currentPage: "login"
    viewState:
      posting: false
      errors: null

    cancel: ->
      $modalInstance.dismiss('cancel')

    changePage: (pageName) ->
      if pageName == 'forget'
        $modalInstance.dismiss('cancel')
        $state.go('forgot')
        return
      $scope.currentPage = pageName

    login: (form) ->
      if !form.$valid then return
      $scope.viewState.posting = true
      $scope.viewState.errors = null
      Auth.login(
        email: $scope.user.email
        password: $scope.user.password
      ).then ->
        Auth.getCurrentUser().$promise.then (me)->
          $modalInstance.close()
          $scope.viewState.posting = false
          $scope.$emit 'loginSuccess', me
      .catch (error) ->
        $scope.viewState.errors = error
        $scope.viewState.posting = false
        if error.unactivated
          $modalInstance.close()
          $modal.open
            templateUrl: 'app/directives/loginForm/activateModal.html'
            controller: 'ActivateModalCtrl'
            windowClass: 'login-window-modal'
            size: 'sm'
            resolve:
              email: -> $scope.user.email
              orgId: -> org._id
          .result.then () ->
            notify
              message: "一封激活邮件即将发送到'#{$scope.user.email}'，请注意查收。"
              classes: 'alert-success'
              duration: 10000

    signup: (form) ->
      if !form.$valid then return
      $scope.viewState.posting = true
      $scope.viewState.errors = null
      Restangular.all('register/user').post
        name: $scope.user.name
        email: $scope.user.email
        password: $scope.user.password
      .then (res)->
        $scope.viewState.posting = false
        notify
          message: "注册成功，一封激活邮件即将发送到'#{$scope.user.email}'，请注意查收。"
          classes: 'alert-success'
          duration: 15000
        $modalInstance.close()
      .catch (err) ->
        console.log err
        $scope.viewState.posting = false
        $scope.viewState.errors = err?.data?.errors
        # Update validity of form fields that match the mongoose errors
        angular.forEach err.errors, (error, field) ->
          form[field].$setValidity 'mongoose', false
          $scope.errors[field] = error.message

    checkEmail: (email)->
      $timeout.cancel(checkEmailPromise)
      if email.$modelValue
        email.$remoteChecked = 'pending'
        email.$setValidity 'remote', true
        checkEmailPromise = $timeout ->
          Restangular.one('users','check').get(email: email.$modelValue)
          .then (data)->
            email.$setValidity 'remote', true
            email.$remoteChecked = true
          , (err)->
            email.$setValidity 'remote', false
            email.$remoteChecked = false
        , 800
