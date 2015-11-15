fs = require 'fs'
path = require 'path'
{ $ } = require 'atom-space-pen-views'
{ BufferedProcess, Emitter } = require 'atom'

module.exports =
class AtoumRunner extends Emitter
    constructor: ->
        super()

        @path = atom.packages.resolvePackagePath('atom-plugin') + '/resources/atoum.phar'
        atom.workspace.project.getPaths().some (path) =>
            if fs.existsSync path + '/bin/atoum'
                @path = path + '/bin/atoum'

            if fs.existsSync path + '/vendor/bin/atoum'
                @path = path + '/vendor/bin/atoum'

            if fs.existsSync path + '/vendor/atoum/atoum/bin/atoum'
                @path = path + '/vendor/atoum/atoum/bin/atoum'

    start: (target = null) ->
        out = (data) => @emit 'output', data

        if target instanceof HTMLElement
            unless $(target).is('span')
                target = $(target).find('span')

            @target = $(target).attr('data-path')
        else
            @target = target if target

        return unless @target

        args = [@path, '-utr', '-mcn', '4', '-ncc', '+verbose']
        if fs.statSync(@target).isDirectory()
            args.push '-d'
            cwd = @target
        else
            args.push '-f'
            cwd = path.dirname @target

        args.push @target

        @running = true
        @emit 'start'
        out 'php ' + args.join(' ') + '\n'
        out 'in ' + cwd

        @process = new BufferedProcess
            command: 'php'
            args: args
            options:
                cwd: cwd + '/../..'
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
