class App extends Controller
  constructor: (@$scope, @$rootScope, @$element) ->
    do @cache_DOM_elements
    do @set_triggers

  cache_DOM_elements: ->
    @loader = $(@$element.find('#loader'))

  set_triggers: ->
    @$scope.$on 'show_loader', @show_loader
    @$scope.$on 'hide_loader', @hide_loader

  show_loader: =>
    @loader.fadeIn 'fast'

  hide_loader: =>
    @loader.fadeOut 'fast'