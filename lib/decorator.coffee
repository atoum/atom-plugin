{ CompositeDisposable } = require 'atom'

module.exports =
class AtoumDecorator
    constructor: ->
        @reset()

    reset: ->
        @subscriptions?.dispose()

        @subscriptions = new CompositeDisposable
        @markers = {}

    findLineStart: (line) ->
        line.length - line.replace(/^\s*/g, '').length

    findLineEnd: (line) ->
        line.replace(/\s*$/g, '').length

    addTest: (test) ->
        return if test.status is 'ok'

        @markers[test.file] = [] unless @markers[test.file]
        @markers[test.file].push(test)

    decorate: (editor, file) ->
        return unless @markers[file]

        gutter = editor.gutterWithName 'atoum'

        unless gutter
            gutter = editor.addGutter
                name: 'atoum'
                priority: 100

        @markers[file].forEach (test, index) =>
            return unless test.line

            line = editor.lineTextForBufferRow(test.line - 1)
            range = [[test.line - 1, @findLineStart(line)], [test.line - 1, @findLineEnd(line)]]
            marker = editor.markBufferRange range, invalidate: 'touch'

            editor.decorateMarker marker, type: 'highlight', class: 'failing'
            gutter.decorateMarker marker,
                type: 'gutter',
                class: 'failing',
                item: document.createElement('span')

            @subscriptions.add marker.onDidChange (event) =>
                @markers[test.file].splice index, 1 unless event.isValid
