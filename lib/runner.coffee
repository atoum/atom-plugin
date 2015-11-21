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
        unless fs.statSync(directory).isDirectory()
            @emit 'error', directory + 'is not a directory'
            @didExit 255

            false
        else
            @target = directory

            @start()

    shouldRunFile: (file) ->
        if fs.statSync(file).isDirectory()
            @emit 'error', file + 'is a directory'
            @didExit 255

            false
        else
            @target = file

            @start()

    start: ->
        out = (data) => @emit 'output', data

        if fs.statSync(@target).isDirectory()
            cwd = @target
        else
            cwd = path.dirname @target

        @emit 'start'
        args = @configurator.getArguments @target

        if not args
            @emit 'error', 'Could not find atoum binary'
            @didExit 255

            false
        else
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

    configChanged: (@config) ->
