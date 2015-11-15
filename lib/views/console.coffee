{ View } = require 'atom-space-pen-views'

module.exports =
class AtoumConsoleView extends View
    @content: ->
        @div class: 'console', =>
            @pre outlet: 'content', ''

    setRunner: (@runner) ->
        @reset()

        @runner.on 'start', =>
            @reset()

        @runner.on 'output', (data) =>
            return if data.toString().replace(/\s/g, '') is ''

            @write data.toString()

        @runner.on 'error', (data) =>
            return if data.toString().replace(/\s/g, '') is ''

            @write data.toString()

        @runner.on 'stop', =>
            @scroll()

    reset: ->
        @content.html ''

    scroll: ->
        @content.parents('.console').stop().animate scrollTop: @content.prop 'scrollHeight'

    write: (data) ->
        @content.html @content.html() + data
        @scroll()
