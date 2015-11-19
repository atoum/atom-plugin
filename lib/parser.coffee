fs = require 'fs'
{ Emitter } = require 'atom'

class Test
    id: null
    status: null
    class: null
    method: null
    skipped: false
    diag: ''
    file: null
    line: null

module.exports =
class AtoumParser extends Emitter
    constructor: ->
        super()

        @reset()

    dispose: ->
        @flush()
        super()

    runnerDidStart: ->
        @reset()

    runnerDidProduceOutput: (data) ->
        @parse data

    runnerDidStop: (code) ->
        return if code is 255

        @flush()

    reset: ->
        @test = null

    parse: (data = '') ->
        data.split('\n')
            .filter (line) -> line.length > 0
            .forEach (line) => @parseLine(line)

    flush: ->
        @emit 'test', @test unless @test is null
        @reset()

    parseLine: (line) ->
        matches = line.match(/^\d+..(\d+)$/)
        if matches
            @emit 'plan', parseInt(matches[1], 10)
        else
            matches = line.match(/((?:not )?ok) (\d+)(?: (?:# SKIP|# TODO|-) (.+)::(.+)\(\))?$/)
            if matches
                @flush()

                @test = new Test()
                @test.id = matches[2]
                @test.status = matches[1]
                @test.class = matches[3]
                @test.method = matches[4]

                if line.match(/# SKIP/)
                    @test.status = 'skip'

                if line.match(/# TODO/)
                    @test.status = 'void'
            else
                matches = line.match(/^# (.+)::(.+)\(\)$/)
                if matches
                    @test.class = matches[1]
                    @test.method = matches[2]
                else
                    matches = line.match(/^# (.+?)(?:\:(\d+))?$/)
                    if matches
                        if fs.existsSync(matches[1])
                            @test.file = matches[1]
                            @test.line = parseInt(matches[2], 10) if matches[2]
                        else
                            @test.diag += line.replace(/^#\s+/g, '') + '\n'
                    else
                        @test.diag += line.replace(/^#\s+/g, '') + '\n' if @test
