{ View } = require 'atom-space-pen-views'

module.exports =
class AtoumProgressView extends View
    @content: ->
        @div class: 'inline-block pull-right', =>
            @progress outlet: 'bar'

    testSuiteStarted: (length) ->
        @bar
            .attr 'max', length
            .attr 'value', 0
            .removeClass 'progress-warning'
            .removeClass 'progress-info'
            .removeClass 'progress-error'

    testSucceeded: ->
        @bar.attr 'value', parseInt(@bar.attr('value'), 10) + 1

    testFailed: ->
        @bar
            .attr 'value', parseInt(@bar.attr('value'), 10) + 1
            .removeClass 'progress-warning'
            .removeClass 'progress-info'
            .addClass 'progress-error'

    testHasBeenSkipped: ->
        @bar
            .attr 'value', parseInt(@bar.attr('value'), 10) + 1
            .addClass 'progress-warning' unless @bar.hasClass 'progress-error'

    testIsVoid: ->
        @bar
            .attr 'value', parseInt(@bar.attr('value'), 10) + 1
            .addClass 'progress-info' unless @bar.hasClass 'progress-error'
