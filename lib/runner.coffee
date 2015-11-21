fs = require 'fs'
path = require 'path'
{ $ } = require 'atom-space-pen-views'
{ BufferedProcess, Emitter } = require 'atom'

module.exports =
class AtoumRunner extends Emitter
    constructor: (@configurator) ->
        super()

    dispose: ->
        @stop()

    shouldRunDirectory: (directory) ->
        try
            unless fs.statSync(directory).isDirectory()
                @emit 'error', directory + 'is not a directory\n'
                @didExit 255

                false
            else
                @target = directory

                @start()
        catch
            @emit 'error', 'Unable to run directory\n'

    shouldRunFile: (file) ->
        try
            if fs.statSync(file).isDirectory()
                @emit 'error', file + 'is a directory\n'
                @didExit 255

                false
            else
                @target = file

                @start()
        catch
            @emit 'error', 'Unable to run file\n'

    start: ->
        out = (data) => @emit 'output', data

        if fs.statSync(@target).isDirectory()
            cwd = @target
        else
            cwd = path.dirname @target

        @emit 'start'
        args = @configurator.getArguments @target

        if not args
            @emit 'error', 'Could not find atoum binary\n'
            @didExit 255

            false
        else
            new BufferedProcess
                command: @config.phpPath
                args: ['-v']
                options:
                    cwd: cwd
                stdout: out
                stderr: (data) => @emit 'error', data
                exit: (code) =>
                    returun unless code is 0

                    out @config.phpPath + ' \'' + args.join('\' \'') + '\'\n'
                    out 'in ' + cwd

                    @process = new BufferedProcess
                        command: @config.phpPath
                        args: args
                        options:
                            cwd: cwd
                        stdout: out
                        stderr: (data) => @emit 'error', data
                        exit: (code) => @didExit code

            true

    stop: ->
        @process?.kill()
        @didExit()

    didExit: (code = -1) ->
        @emit 'stop', code

    configDidChange: (@config) ->
