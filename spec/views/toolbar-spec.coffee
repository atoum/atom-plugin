{ Emitter } = require 'atom'
AtoumToolbarView = require '../../lib/views/toolbar'

describe 'AtoumToolbarView', ->
    view = null

    beforeEach ->
        view = new AtoumToolbarView {}

    it 'has a start/stop button', ->
        expect(view.startStopButton).not.toBe undefined

    describe 'When a runner is set', ->
        it 'should subscribe to start event', ->
            view.runnerDidStart()

            expect(view.startStopButton.is('.icon.icon-circle-slash')).toBe true

        it 'should subscribe to stop event', ->
            view.runnerDidStop()

            expect(view.startStopButton.is('.icon.icon-triangle-right')).toBe true
