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
            view.testSuiteDidStart 10

            expect(view.bar.attr('max')).toBe '10'
            expect(view.bar.attr('value')).toBe '0'

        it 'should reset progress bar style', ->
            view.testSuiteDidStart 1
            view.testDidFail()
            view.testSuiteDidStart 1

            expect(view.bar.hasClass('progress-error')).toBe false

    describe 'When test finishes', ->
        beforeEach ->
            view.testSuiteDidStart 1

        it 'should increment value on success', ->
            view.testDidSucceed()

            expect(view.bar.attr('value')).toBe '1'

        it 'should increment value on failure', ->
            view.testDidFail()

            expect(view.bar.attr('value')).toBe '1'

        it 'should add error class', ->
            view.testDidFail()

            expect(view.bar.hasClass('progress-error')).toBe true

        it 'should increment value on skip', ->
            view.testDidSkip()

            expect(view.bar.attr('value')).toBe '1'

        it 'should add warning class', ->
            view.testDidSkip()

            expect(view.bar.hasClass('progress-warning')).toBe true

        it 'should increment value on void', ->
            view.testDidNothing()

            expect(view.bar.attr('value')).toBe '1'

        it 'should add info class', ->
            view.testDidNothing()

            expect(view.bar.hasClass('progress-info')).toBe true

        it 'should stick with error class', ->
            view.testDidFail()
            view.testDidSkip()
            view.testDidNothing()

            expect(view.bar.hasClass('progress-error')).toBe true
            expect(view.bar.hasClass('progress-warning')).toBe false
            expect(view.bar.hasClass('progress-info')).toBe false
