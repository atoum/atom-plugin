fs = require 'fs'
path = require 'path'
{ $ } = require 'atom-space-pen-views'
{ BufferedProcess, Emitter } = require 'atom'

module.exports =
class AtoumRunner extends Emitter
    constructor: (@configurator) ->
        super()

    start: (target = null) ->
        out = (data) => @emit 'output', data

        if target instanceof HTMLElement
            unless $(target).is('span')
                target = $(target).find 'span'

            @target = $(target).attr 'data-path'
        else
            @target = target if target

        return unless @target

        if fs.statSync(@target).isDirectory()
            cwd = @target
        else
            cwd = path.dirname @target

        @running = true
        @emit 'start'
        args = @configurator.getArguments @target
        out 'php ' + args.join(' ') + '\n'
        out 'in ' + cwd

        @process = new BufferedProcess
            command: 'php'
            args: args
            options:
                cwd: cwd
            stdout: out
            stderr: (data) =>
                @emit 'error', data
            exit: (code) =>
                @didExit code

    stop: ->
        @process?.kill()
        @didExit()

    didExit: (code = -1) ->
        @running = false
        @emit 'stop', code

    configChanged: (@config) ->
