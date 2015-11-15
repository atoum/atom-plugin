process = require 'child_process'

{ CompositeDisposable } = require 'atom'
{ View } = require 'atom-space-pen-views'
AtoumToolbarView = require './toolbar'
AtoumConsoleView = require './console'
AtoumReportView = require './report'
AtoumProgressView = require './progress'
AtoumRunner = require '../runner'

module.exports =
class AtoumPanelView extends View
    @content: (@model) ->
        @div tabIndex: -1, class: 'atoum', =>
            @header class: 'panel-heading', =>
                @span 'atoum'
                @span class: 'subtle-info-message', =>
                    @raw 'Close this panel with the <span class="highlight">esc</span> key'
                @subview 'progress', new AtoumProgressView

            @section class: 'panel-body padded', =>
                @subview 'toolbar', new AtoumToolbarView(@model)
                @subview 'console', new AtoumConsoleView
                @subview 'report', new AtoumReportView


    initialize: (@model, @runner, @parser) ->
        @subscriptions = new CompositeDisposable
        @toolbar.setRunner @runner
        @console.setRunner @runner
        @report.setParser @parser
        @report.setRunner @runner

        @subscriptions.add @toolbar.on 'toggle-view', (view) =>
            @model.view = view
            @toggleView()

        @subscriptions.add @runner.on 'start', =>
            @progress.hide()

        @subscriptions.add @runner.on 'error', =>
            @showConsole()
            @toolbar.displayView()

        @subscriptions.add @parser.on 'plan', (length) =>
            @progress.testSuiteStarted length
            @progress.show()

        @subscriptions.add @parser.on 'test', (test) =>
            @progress.testSucceeded() if test.status is 'ok'
            @progress.testFailed() if test.status is 'not ok'
            @progress.testHasBeenSkipped() if test.status is 'skip'
            @progress.testIsVoid() if test.status is 'void'

    destroy: ->
        @subscriptions.dispose()
        @toolbar.destroy()
        @report.destroy()

    setPanel: (@panel) ->
        @subscriptions.add @panel.onDidChangeVisible (visible) =>
            if visible
                @didShow()

    didShow: ->
        @progress.hide()
        @toggleView()

    toggleView: ->
        if @model.view is 'console' or not @model.view
            @showConsole()

        if @model.view is 'report'
            @showReport()

    showConsole: ->
        @model.view = 'console'

        @console.show()
        @report.hide()

    showReport: ->
        @model.view = 'report'

        @console.hide()
        @report.show()

    serialize: ->
        @model
