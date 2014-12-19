'use strict'

angular.module 'budweiserApp'
.config ($provide) ->
  $provide.decorator 'paginationDirective', ($delegate) ->
    # decorate the $delegate
    directive = $delegate[0];
    directive.templateUrl = 'components/decorators/pagination/pagination.html'
    directive.scope.maxSize = '='
    $delegate
