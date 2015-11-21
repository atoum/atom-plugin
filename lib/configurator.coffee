fs = require 'fs'
AtoumConfiguration = require './configuration'

module.exports =
class AtoumConfigurator
    constructor: (@locator) ->

    configDidChange: (@config) ->

    getArguments: (target = null) ->
        binary = @locator.getBinary()

        return false if not binary

        args = [binary, '-utr', '+verbose']

        args = args.concat ['-mcn', @config.maxChildrenNumber] if @config?.maxChildrenNumber
        args.push '-ncc' if @config?.disableCodeCoverage
        args.push '--debug' if @config?.enableDebugMode
        args = args.concat ['-xc', @config.xdebugConfig] if @config?.xdebugConfig
        args.push '-fivm' if @config?.failIfVoidMethod
        args.push '-fism' if @config?.failIfSkippedMethod
        args = args.concat ['-p', @config.phpPath] if @config?.phpPath

        if @config?.phpArguments and not @config.phpPath
            args = args.concat ['-p', AtoumConfiguration.schema().phpPath.default]

        if @config?.phpArguments
            args[args.length - 1] = args[args.length - 1] + ' ' + @config.phpArguments
            args = @config.phpArguments.split(' ').concat args

        if target
            if fs.statSync(target).isDirectory()
                args = args.concat ['-d', target]
            else
                args = args.concat ['-f', target]

        args
