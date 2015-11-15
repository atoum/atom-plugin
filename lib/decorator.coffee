{ CompositeDisposable } = require 'atom'

module.exports =
class AtoumDecorator
    constructor: (@parser) ->
        @subscriptions = new CompositeDisposable

        @subscriptions.add @parser.on 'test', (test) =>
            return if test.status is 'ok'

            @markers[test.file] = [] unless @markers[test.file]
            @markers[test.file].push(test)

        @subscriptions.add atom.workspace.onDidOpen (event) =>
            return unless @markers[event.uri]

            gutter = event.item.addGutter
                name: 'atoum'
                priority: 100

            @markers[event.uri].forEach (test, index) =>
                line = event.item.lineTextForBufferRow(test.line - 1)
                range = [[test.line - 1, @findLineStart(line)], [test.line - 1, @findLineEnd(line)]]
                marker = event.item.markBufferRange range, invalidate: 'touch'

                event.item.decorateMarker marker, type: 'highlight', class: 'failing'
                gutter.decorateMarker marker,
                    type: 'gutter',
                    class: 'failing',
                    item: document.createElement('span')

                @subscriptions.add marker.onDidChange (event) =>
                    @markers[test.file].splice index, 1 unless event.isValid

        @reset()

    destroy: ->
        @subscriptions.dispose()

    reset: ->
        @markers = {}

    findLineStart: (line) ->
        line.length - line.replace(/^\s*/g, '').length

    findLineEnd: (line) ->
        line.replace(/\s*$/g, '').length
