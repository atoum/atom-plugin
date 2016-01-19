{ CompositeDisposable } = require 'atom'

module.exports =
class AtoumDecorator
    constructor: ->
        @reset()

    dispose: ->
        @reset()
        @subscriptions.dispose()

    runnerDidStart: ->
        @reset()

    reset: ->
        @subscriptions?.dispose()

        @subscriptions = new CompositeDisposable
        @markers = {}

    findLineStart: (line) ->
        line.length - line.replace(/^\s*/g, '').length

    findLineEnd: (line) ->
        line.replace(/\s*$/g, '').length

    testDidFinish: (test) ->
        return if test.status is 'ok'

        @markers['test'] = {} unless @markers['test']
        @markers['test'][test.file] = [] unless @markers['test'][test.file]
        @markers['test'][test.file].push(test)

    fileDidCover: (file) ->
        @markers['coverage'] = {} unless @markers['coverage']
        @markers['coverage'][file.path] = file

    editorDidOpenFile: (editor, file) ->
        @decorateTest editor, file
        @decorateCoverage editor, file

    decorateCoverage: (editor, file) ->
        return unless @markers['coverage'] and @markers['coverage'][file]

        gutter = editor.gutterWithName 'atoum-coverage'

        unless gutter
            gutter = editor.addGutter
                name: 'atoum'
                priority: 300

        @markers['coverage'][file].lines.forEach ([num, count], index) =>
            line = editor.lineTextForBufferRow(num - 1)
            range = [[num - 1, @findLineStart(line)], [num - 1, @findLineEnd(line)]]
            marker = editor.markBufferRange range, invalidate: 'touch'

            cssClass = 'uncovered'
            cssClass = 'covered' if count > 0
            gutter.decorateMarker marker,
                type: 'gutter'
                class: cssClass
                item: document.createElement('span')

            @subscriptions.add marker.onDidChange (event) =>
                @markers['coverage'][file].lines.splice index, 1 unless event.isValid

    decorateTest: (editor, file) ->
        return unless @markers['test'] and @markers['test'][file]

        gutter = editor.gutterWithName 'atoum-test'

        unless gutter
            gutter = editor.addGutter
                name: 'atoum'
                priority: 300

        @markers['test'][file].forEach (test, index) =>
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
                @markers['test'][test.file].splice index, 1 unless event.isValid
