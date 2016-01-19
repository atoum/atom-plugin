{ CompositeDisposable } = require 'atom'
{ View } = require 'atom-space-pen-views'

module.exports =
class AtoumToolbarView extends View
    @content: (@runner, @subviews) ->
        @div =>
            @div class: 'toolbar', =>
                @a click: 'startStop', =>
                    @i outlet: 'startStopButton', class: 'icon icon-triangle-right'
                for name, view of @subviews
                    @subview name + 'Button', view.button()

            for name, view of @subviews
                @subview name, view

    initialize: (@runner, @subviews) ->

    startStop: ->
        if @running
            @runner?.stop()
        else
            @runner?.start()

    runnerDidStart: ->
        @running = true

        for name, view of @subviews
            view.runnerDidStart()

        @startStopButton.addClass 'icon-circle-slash'
        @startStopButton.removeClass 'icon-triangle-right'

    runnerDidProduceOutput: (data) ->
        for name, view of @subviews
            view.runnerDidProduceOutput data

    runnerDidProduceError: (data) ->
        for name, view of @subviews
            view.runnerDidProduceError data

    runnerDidStop: ->
        @running = false

        for name, view of @subviews
            view.runnerDidStop()

        @startStopButton.addClass 'icon-triangle-right'
        @startStopButton.removeClass 'icon-circle-slash'

    testDidFinish: (test) ->
        for name, view of @subviews
            view.testDidFinish test
