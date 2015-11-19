{ Emitter } = require 'atom'
AtoumToolbarView = require '../../lib/views/toolbar'

describe 'AtoumToolbarView', ->
    view = null

    beforeEach ->
        view = new AtoumToolbarView {}

    it 'has a start/stop button', ->
        expect(view.startStopButton).not.toBe undefined

    it 'has a view switch button', ->
        expect(view.viewButton).not.toBe undefined

    describe 'When a model is provided with console view', ->
        beforeEach ->
            view = new AtoumToolbarView view: 'console'

        it 'has a view switch button to display the report view', ->
            expect(view.viewButton.is('.icon.icon-list-unordered')).toBe true

    describe 'When a model is provided with report view', ->
        beforeEach ->
            view = new AtoumToolbarView view: 'report'

        it 'has a view switch button to display the report view', ->
            expect(view.viewButton.is('.icon.icon-terminal')).toBe true

    describe 'When a runner is set', ->
        it 'should subscribe to start event', ->
            view.runnerDidStart()

            expect(view.startStopButton.is('.icon.icon-circle-slash')).toBe true

        it 'should subscribe to stop event', ->
            view.runnerDidStop()

            expect(view.startStopButton.is('.icon.icon-triangle-right')).toBe true
