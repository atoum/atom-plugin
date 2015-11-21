AtoumNotifier = require '../lib/notifier'

describe 'AtoumNotifier', ->
    notifications = null
    notification = null
    notifier = null

    beforeEach ->
        notification =
            dismiss: ->
            onDidDismiss: ->
        notifications =
            addSuccess: ->
            addWarning: ->
            addError: ->

        spyOn(notification, 'dismiss').andCallFake ->
        spyOn(notification, 'onDidDismiss').andCallFake ->

        returnNotification = -> notification
        spyOn(notifications, 'addSuccess').andCallFake returnNotification
        spyOn(notifications, 'addWarning').andCallFake returnNotification
        spyOn(notifications, 'addError').andCallFake returnNotification

    beforeEach ->
        notifier = new AtoumNotifier notifications

    it 'should initialize with empty scores', ->
        expect(notifier.count).toBe 0
        expect(notifier.failure).toBe 0
        expect(notifier.skip).toBe 0
        expect(notifier.voidNumber).toBe 0

    it 'should be enabled', ->
        expect(notifier.enabled).toBe true

    describe 'When disabled', ->
        beforeEach ->
            notifier.disable()

        afterEach ->
            expect(notifications.addSuccess).not.toHaveBeenCalled()
            expect(notifications.addWarning).not.toHaveBeenCalled()
            expect(notifications.addError).not.toHaveBeenCalled()

        it 'should not send notification for success', ->
            notifier.testDidFinish status: 'ok'

            notifier.runnerDidStop 0

        it 'should not send notification for failure', ->
            notifier.testDidFinish status: 'not ok'

            notifier.runnerDidStop 1

        it 'should not send notification for void', ->
            notifier.testDidFinish status: 'void'

            notifier.runnerDidStop 0

        it 'should not send notification for skip', ->
            notifier.testDidFinish status: 'skip'

            notifier.runnerDidStop 0

        it 'should not send notification for errors', ->
            notifier.testDidFinish status: 'success'

            notifier.runnerDidStop 255

    describe 'When enabled', ->
        beforeEach ->
            notifier.enable()

        it 'should send notification for success', ->
            notifier.testDidFinish status: 'ok'

            notifier.runnerDidStop 0

            expect(notifications.addSuccess).toHaveBeenCalled()

        it 'should send notification for failure', ->
            notifier.testDidFinish status: 'not ok'

            notifier.runnerDidStop 1

            expect(notifications.addError).toHaveBeenCalled()

        it 'should send notification for void', ->
            notifier.testDidFinish status: 'void'

            notifier.runnerDidStop 0

            expect(notifications.addWarning).toHaveBeenCalled()

        it 'should send notification for skip', ->
            notifier.testDidFinish status: 'skip'

            notifier.runnerDidStop 0

            expect(notifications.addWarning).toHaveBeenCalled()

        it 'should send notification for errors', ->
            notifier.testDidFinish status: 'success'

            notifier.runnerDidStop 255

            expect(notifications.addError).toHaveBeenCalled()

        it 'should dismiss outdated notification', ->
            notifier.testDidFinish status: 'ok'

            notifier.runnerDidStop 0

            expect(notifications.addSuccess).toHaveBeenCalled()

            notifier.reset()

            expect(notification.dismiss).toHaveBeenCalled()

        it 'should dismiss outdated notification even if it gets disabled', ->
            notifier.testDidFinish status: 'ok'

            notifier.runnerDidStop 0

            expect(notifications.addSuccess).toHaveBeenCalled()

            notifier.disable()
            notifier.reset()

            expect(notification.dismiss).toHaveBeenCalled()

        describe 'Success notification', ->
            beforeEach ->
                notifier.testDidFinish status: 'ok'

            afterEach ->
                notifier.runnerDidStop 0
                expect(notifications.addSuccess).toHaveBeenCalled()

            it 'should be dismissable', ->
                notifications.addSuccess.andCallFake (title, options) ->
                    expect(options.dismissable).toBe true

                    notification

            it 'should have a check icon', ->
                notifications.addSuccess.andCallFake (title, options) ->
                    expect(options.icon).toBe 'check'

                    notification

            it 'should display a message with the number of tests', ->
                notifications.addSuccess.andCallFake (title, options) ->
                    expect(options.detail).toBe '1 test passed!'

                    notification

        describe 'Failure notification', ->
            beforeEach ->
                notifier.testDidFinish status: 'ok'
                notifier.testDidFinish status: 'not ok'

            afterEach ->
                notifier.runnerDidStop 1
                expect(notifications.addError).toHaveBeenCalled()

            it 'should be dismissable', ->
                notifications.addError.andCallFake (title, options) ->
                    expect(options.dismissable).toBe true

                    notification

            it 'should have a flame icon', ->
                notifications.addError.andCallFake (title, options) ->
                    expect(options.icon).toBe 'flame'

                    notification

            it 'should display a message with the number of tests', ->
                notifications.addError.andCallFake (title, options) ->
                    expect(options.detail).toBe '1 of 2 tests failed!'

                    notification

        describe 'Void and skip notification', ->
            beforeEach ->
                notifier.testDidFinish status: 'ok'
                notifier.testDidFinish status: 'void'
                notifier.testDidFinish status: 'skip'

            afterEach ->
                notifier.runnerDidStop 0
                expect(notifications.addWarning).toHaveBeenCalled()

            it 'should be dismissable', ->
                notifications.addWarning.andCallFake (title, options) ->
                    expect(options.dismissable).toBe true

                    notification

            it 'should have a dot icon', ->
                notifications.addWarning.andCallFake (title, options) ->
                    expect(options.icon).toBe 'primitive-dot'

                    notification

            it 'should display a message with the number of tests', ->
                notifications.addWarning.andCallFake (title, options) ->
                    expect(options.detail).toBe '1 test passed, 1 test was void and 1 test was skipped.'

                    notification

        describe 'Error notification', ->
            beforeEach ->
                notifier.testDidFinish status: 'ok'
                notifier.testDidFinish status: 'not ok'
                notifier.testDidFinish status: 'void'
                notifier.testDidFinish status: 'skip'

            afterEach ->
                notifier.runnerDidStop 255
                expect(notifications.addError).toHaveBeenCalled()

            it 'should be dismissable', ->
                notifications.addError.andCallFake (title, options) ->
                    expect(options.dismissable).toBe true

                    notification

            it 'should have a flame icon', ->
                notifications.addError.andCallFake (title, options) ->
                    expect(options.icon).toBe 'flame'

                    notification

            it 'should display a message with the number of tests', ->
                notifications.addError.andCallFake (title, options) ->
                    expect(options.detail).toBe 'There was an error while running your tests!'

                    notification
