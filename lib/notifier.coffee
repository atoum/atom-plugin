{ CompositeDisposable, Emitter } = require 'atom'

module.exports =
class AtoumNotifier extends Emitter
    constructor: (@notifications) ->
        super()

        @reset()
        @enable()

    dispose: ->
        @subscriptions.dispose()

    reset: ->
        @count = 0
        @failure = 0
        @skip = 0
        @voidNumber = 0

        @subscriptions?.dispose()
        @notification?.dismiss()
        @subscriptions = new CompositeDisposable

    enable: ->
        @enabled = true

    disable: ->
        @enabled = false

    testDidFinish: (status) ->
        @count += 1
        @failure += 1 if status is 'not ok'
        @skip += 1 if status is 'skip'
        @voidNumber += 1 if status is 'void'

    runnerDidStop: (code) ->
        return unless @enabled and (@count > 0 or code > 0)

        if code is 0 and @skip is 0 and @voidNumber is 0
            @notification = @notifications.addSuccess 'Tests passed',
                detail: @count + ' test(s) passed!'
                dismissable: true
                icon: 'check'

        if code is 0 and (@skip isnt 0 or @voidNumber isnt 0)
            @notification = @notifications.addWarning 'Tests passed',
                detail: @count + ' test(s) passed with ' + @voidNumber + ' void test(s) and ' + @skip + ' skipped test(s).'
                dismissable: true
                icon: 'primitive-dot'

        if code is 255
            @notification = @notifications.addError 'atoum error',
                detail: 'There was an error when running tests!'
                dismissable: true
                icon: 'flame'
        else if code > 0
            @notification = @notifications.addError 'Tests failed',
                detail: @failure + ' of ' + @count + ' test(s) failed!'
                dismissable: true
                icon: 'flame'

        if code > 0 or @skip isnt 0 or @voidNumber isnt 0
            @subscriptions.add @notification.onDidDismiss => @emit 'dismiss', @notification
