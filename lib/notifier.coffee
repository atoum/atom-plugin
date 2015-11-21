{ CompositeDisposable, Emitter } = require 'atom'

module.exports =
class AtoumNotifier extends Emitter
    constructor: (@notifications) ->
        super()

        @reset()
        @enable()

    dispose: ->
        @reset()

    runnerDidStart: ->
        @reset()

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

    testDidFinish: (test) ->
        @count += 1
        @failure += 1 if test.status is 'not ok'
        @skip += 1 if test.status is 'skip'
        @voidNumber += 1 if test.status is 'void'

    runnerDidStop: (code) ->
        return unless @enabled and (@count > 0 or code > 0)

        if @failure > 0
            code = 1

        if code is 0
            if @skip is 0 and @voidNumber is 0
                @notifySuccess 'Tests passed', @count + ' ' + @pluralize('test' , 'tests', @count) + ' passed!'
            else
                @notifyWarning 'Tests passed', (@count - @voidNumber - @skip) + ' ' + @pluralize('test' , 'tests', @count - @voidNumber - @skip) + ' passed, ' + @voidNumber + ' ' + @pluralize('test' , 'tests', @voidNumber) + ' ' + @pluralize('was', 'were', @voidNumber) + ' void and ' + @skip + ' ' + @pluralize('test' , 'tests', @skip) + ' ' + @pluralize('was' , 'were', @skip) + ' skipped.'
        else if code is 255
            @notifyFailure 'atoum error', 'There was an error while running your tests!'
        else if ((@config?.failIfVoidMethod and @voidNumber isnt 0) or (@config?.failIfSkippedMethod and @skip isnt 0)) and @failure is 0
            @notifyFailure 'Tests failed', (@count - @voidNumber - @skip) + ' ' + @pluralize('test' , 'tests', @count - @voidNumber - @skip) + ' passed, ' + @voidNumber + ' ' + @pluralize('test' , 'tests', @voidNumber) + ' ' + @pluralize('was', 'were', @voidNumber) + ' void and ' + @skip + ' ' + @pluralize('test' , 'tests', @skip) + ' ' + @pluralize('was' , 'were', @skip) + ' skipped.'
        else
            @notifyFailure 'Tests failed', @failure + ' of ' + @count + ' ' + @pluralize('test' , 'tests', @count) + ' failed!'

    configDidChange: (@config) ->

    notifySuccess: (title, message) ->
        @notification = @notifications.addSuccess title,
            detail: message
            dismissable: true
            icon: 'check'

    notifyWarning: (title, message) ->
        @notification = @notifications.addWarning title,
            detail: message
            dismissable: true
            icon: 'primitive-dot'

    notifyFailure: (title, message) ->
        @notification = @notifications.addError title,
            detail: message
            dismissable: true
            icon: 'flame'

        @subscriptions.add @notification.onDidDismiss => @emit 'dismiss', @notification

    pluralize: (singular, plural, count) ->
        if count > 0 and count < 2
            singular
        else
            plural
