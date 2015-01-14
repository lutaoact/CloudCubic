angular.module('budweiserApp')

.directive 'loginWindow', (
  Auth
  $modal
) ->
  restrict: 'A'
  scope:
    loginSuccess: '&'

  link: (scope, element) ->
    element.bind 'click', ()->
      if !Auth.isLoggedIn()
        $modal.open
          templateUrl: 'app/login/loginModal.html'
          controller: 'loginModalCtrl'
          windowClass: 'login-window-modal'
          size: 'md'
        .result.then ->
          scope.loginSuccess?()
      else
        scope.loginSuccess?()
