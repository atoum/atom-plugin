{ View } = require 'atom-space-pen-views'
AtoumConsoleView = require './console'
AtoumReportView = require './report'
AtoumResultButtonView = require './result-button'

module.exports =
class AtoumResultView extends View
    @content: (@model) ->
        @div =>
            @subview 'console', new AtoumConsoleView
            @subview 'report', new AtoumReportView

    initialize: (@model) ->
        @displayView()

    button: ->
        @button = new AtoumResultButtonView @model
        @button.on 'click', => @displayView()

    runnerDidStart: ->
        @console.runnerDidStart()
        @report.runnerDidStart()

    runnerDidProduceOutput: (data) ->
        @console.runnerDidProduceOutput data

    runnerDidProduceError: (data) ->
        @console.runnerDidProduceError data

    runnerDidStop: ->
        @console.runnerDidStop()

    testDidFinish: (test) ->
        @report.testDidFinish test

    displayView: ->
        if @model.view is 'console'
            @console.css('display', '')
            @report.hide()

        if @model.view is 'report' or not @model.view
            @report.css('display', '')
            @console.hide()
