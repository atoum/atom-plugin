AtomProgressView = require '../../lib/views/progress'

describe 'AtoumProgressView', ->
    view = null

    beforeEach ->
        view = new AtomProgressView

    it 'has a progress bar', ->
        expect(view.bar).not.toBe undefined

    it 'initializes with an empty bar', ->
        expect(view.bar.attr('max')).toBe undefined
        expect(view.bar.attr('value')).toBe undefined

    describe 'When test suite starts', ->
        it 'should use plan length as max value', ->
            view.testSuiteStarted 10

            expect(view.bar.attr('max')).toBe '10'
            expect(view.bar.attr('value')).toBe '0'

        it 'should reset progress bar style', ->
            view.testSuiteStarted 1
            view.testFailed()
            view.testSuiteStarted 1

            expect(view.bar.hasClass('progress-error')).toBe false

    describe 'When test finishes', ->
        beforeEach ->
            view.testSuiteStarted 1

        it 'should increment value on success', ->
            view.testSucceeded()

            expect(view.bar.attr('value')).toBe '1'

        it 'should increment value on failure', ->
            view.testFailed()

            expect(view.bar.attr('value')).toBe '1'

        it 'should add error class', ->
            view.testFailed()

            expect(view.bar.hasClass('progress-error')).toBe true

        it 'should increment value on skip', ->
            view.testHasBeenSkipped()

            expect(view.bar.attr('value')).toBe '1'

        it 'should add warning class', ->
            view.testHasBeenSkipped()

            expect(view.bar.hasClass('progress-warning')).toBe true

        it 'should increment value on void', ->
            view.testIsVoid()

            expect(view.bar.attr('value')).toBe '1'

        it 'should add info class', ->
            view.testIsVoid()

            expect(view.bar.hasClass('progress-info')).toBe true

        it 'should stick with error class', ->
            view.testFailed()
            view.testHasBeenSkipped()
            view.testIsVoid()

            expect(view.bar.hasClass('progress-error')).toBe true
            expect(view.bar.hasClass('progress-warning')).toBe false
            expect(view.bar.hasClass('progress-info')).toBe false
