{ CompositeDisposable } = require 'atom'
{ View } = require 'atom-space-pen-views'
AtoumConsoleView = require './console'
AtoumReportView = require './report'

module.exports =
class AtoumToolbarView extends View
    @content: ->
        @div =>
            @div class: 'toolbar', =>
                @a click: 'startStop', =>
                    @i outlet: 'startStopButton', class: 'icon icon-triangle-right'
                @a click: 'toggleView', =>
                    @i outlet: 'viewButton', class: 'icon icon-terminal'
            @subview 'console', new AtoumConsoleView
            @subview 'report', new AtoumReportView

    initialize: (@model, @runner) ->
        @displayView()

    startStop: ->
        if @running
            @runner?.stop()
        else
            @runner?.start()

    runnerDidStart: ->
        @running = true

        @console.runnerDidStart()
        @report.runnerDidStart()
        @startStopButton.addClass 'icon-circle-slash'
        @startStopButton.removeClass 'icon-triangle-right'

    runnerDidProduceOutput: (data) ->
        @console.runnerDidProduceOutput data

    runnerDidProduceError: (data) ->
        @console.runnerDidProduceError data

    runnerDidStop: ->
        @running = false

        @console.runnerDidStop()
        @startStopButton.addClass 'icon-triangle-right'
        @startStopButton.removeClass 'icon-circle-slash'

    testDidFinish: (test) ->
        @report.testDidFinish test

    toggleView: ->
        if @model.view is 'console'
            @model.view = 'report'
        else
            @model.view = 'console'

        @displayView()

    displayView: ->
        if @model.view is 'console'
            @viewButton.addClass('icon-list-unordered').removeClass('icon-terminal')
            @console.css('display', '')
            @report.hide()

        if @model.view is 'report' or not @model.view
            @viewButton.addClass('icon-terminal').removeClass('icon-list-unordered')
            @report.css('display', '')
            @console.hide()
