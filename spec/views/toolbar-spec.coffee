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
        runner = null

        beforeEach ->
            runner = new Emitter
            runner.running = false

            view.setRunner runner

        it 'should subscribe to start event', ->
            runner.emit 'start'

            expect(view.startStopButton.is('.icon.icon-circle-slash')).toBe true

        it 'should subscribe to stop event', ->
            runner.emit 'stop'

            expect(view.startStopButton.is('.icon.icon-triangle-right')).toBe true

    describe 'When another runner is set', ->
        runner = null

        beforeEach ->
            runner = new Emitter
            runner.running = false

            view.setRunner runner

        it 'should unsubscribe from runner', ->
            newRunner = new Emitter
            newRunner.running = false

            view.setRunner newRunner
            runner.emit 'start'

            expect(view.startStopButton.is('.icon.icon-circle-slash')).toBe false
