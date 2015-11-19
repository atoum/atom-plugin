process = require 'child_process'

{ CompositeDisposable } = require 'atom'
{ View } = require 'atom-space-pen-views'
AtoumToolbarView = require './toolbar'
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
                @subview 'toolbar', new AtoumToolbarView @model, @runner


    initialize: (@model, @runner) ->
        @subscriptions = new CompositeDisposable

    dispose: ->
        @subscriptions.dispose()

    runnerDidStart: ->
        @progress.hide()
        @toolbar.runnerDidStart()

    runnerDidProduceOutput: (data) ->
        @toolbar.runnerDidProduceOutput data

    runnerDidProduceError: (data) ->
        @toolbar.runnerDidProduceError()

    runnerDidStop: ->
        @toolbar.runnerDidStop()

    testPlanDidStart: (length) ->
        @progress.testSuiteStarted length
        @progress.show()

    testDidFinish: (test) ->
        @toolbar.testDidFinish test
        @progress.testSucceeded() if test.status is 'ok'
        @progress.testFailed() if test.status is 'not ok'
        @progress.testHasBeenSkipped() if test.status is 'skip'
        @progress.testIsVoid() if test.status is 'void'

    setPanel: (@panel) ->
        @subscriptions.add @panel.onDidChangeVisible (visible) =>
            if visible
                @didShow()

    didShow: ->
        @progress.hide()

    serialize: ->
        @model
