class RescueDirective extends Directive
  constructor: ->
    return {
      restrict: 'E'
      templateUrl: '/partials/directives/rescue.html'
      controller: 'rescueController'
    }