{ View } = require 'atom-space-pen-views'

module.exports =
class AtoumProgressView extends View
    @content: ->
        @div class: 'inline-block pull-right', =>
            @progress outlet: 'bar'

    increment: ->
        @value++

        @bar.attr 'value', @value

    testSuiteDidStart: (length) ->
        @value = 0

        @bar
            .attr 'max', length
            .attr 'value', @value
            .removeClass 'progress-warning'
            .removeClass 'progress-info'
            .removeClass 'progress-error'

    testDidSucceed: ->
        @increment()

    testDidFail: ->
        @increment()

        @bar
            .removeClass 'progress-warning'
            .removeClass 'progress-info'
            .addClass 'progress-error'

    testDidSkip: ->
        @increment()

        @bar.addClass 'progress-warning' unless @bar.hasClass 'progress-error'

    testDidNothing: ->
        @increment()

        @bar.addClass 'progress-info' unless @bar.hasClass 'progress-error'
