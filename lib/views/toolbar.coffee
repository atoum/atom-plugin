{ CompositeDisposable, Emitter } = require 'atom'
{ View } = require 'atom-space-pen-views'

module.exports =
class AtoumToolbarView extends View
    @content: ->
        @div class: 'toolbar', =>
            @a click: 'startStop', =>
                @i outlet: 'startStopButton', class: 'icon icon-triangle-right'
            @a click: 'toggleView', =>
                @i outlet: 'viewButton', class: 'icon icon-terminal'

    initialize: (@model) ->
        @emitter = new Emitter
        @displayView()

    dispose: ->
        @subscriptions?.dispose()
        @emitter.dispose()

    on: (event, handler) ->
        @emitter.on(event, handler)

    setRunner: (@runner) ->
        @subscriptions?.dispose()

        if @runner.running
            @runnerDidStart()
        else
            @runnerDidStop()

        @subscriptions = new CompositeDisposable
        @subscriptions.add @runner.on 'start', =>
            @runnerDidStart()

        @subscriptions.add @runner.on 'stop', =>
            @runnerDidStop()

    startStop: ->
        if @runner?.running
            @runner?.stop()
        else
            @runner?.start()

    runnerDidStart: ->
        @startStopButton.addClass 'icon-circle-slash'
        @startStopButton.removeClass 'icon-triangle-right'

    runnerDidStop: ->
        @startStopButton.addClass 'icon-triangle-right'
        @startStopButton.removeClass 'icon-circle-slash'

    toggleView: ->
        if @model.view is 'console'
            @model.view = 'report'
        else
            @model.view = 'console'

        @displayView()

        @emitter.emit 'toggle-view', @model.view

    displayView: ->
        if @model.view is 'console'
            @viewButton.addClass('icon-list-unordered').removeClass('icon-terminal')

        if @model.view is 'report' or not @model.view
            @viewButton.addClass('icon-terminal').removeClass('icon-list-unordered')
