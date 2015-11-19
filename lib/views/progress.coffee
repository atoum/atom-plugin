{ View } = require 'atom-space-pen-views'

module.exports =
class AtoumProgressView extends View
    @content: ->
        @div class: 'inline-block pull-right', =>
            @progress outlet: 'bar'

    increment: ->
        @value++

        @bar.attr 'value', @value

    testSuiteStarted: (length) ->
        @value = 0

        @bar
            .attr 'max', length
            .attr 'value', @value
            .removeClass 'progress-warning'
            .removeClass 'progress-info'
            .removeClass 'progress-error'

    testSucceeded: ->
        @increment()

    testFailed: ->
        @increment()

        @bar
            .removeClass 'progress-warning'
            .removeClass 'progress-info'
            .addClass 'progress-error'

    testHasBeenSkipped: ->
        @increment()

        @bar.addClass 'progress-warning' unless @bar.hasClass 'progress-error'

    testIsVoid: ->
        @increment()

        @bar.addClass 'progress-info' unless @bar.hasClass 'progress-error'
