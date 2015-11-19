{ View } = require 'atom-space-pen-views'

module.exports =
class AtoumConsoleView extends View
    @content: ->
        @div class: 'console', =>
            @pre outlet: 'content', ''

    runnerDidStart: ->
        @reset()

    runnerDidStop: ->
        @scroll()

    runnerDidProduceOutput: (data) ->
        return if data.toString().replace(/\s/g, '') is ''

        @write data.toString()

    runnerDidProduceError: (data) ->
        return if data.toString().replace(/\s/g, '') is ''

        @write data.toString()

    reset: ->
        @content.html ''

    scroll: ->
        @content.parents('.console').stop().animate scrollTop: @content.prop 'scrollHeight'

    write: (data) ->
        @content.html @content.html() + data
        @scroll()
