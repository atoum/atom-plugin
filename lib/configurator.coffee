fs = require 'fs'

module.exports =
class AtoumConfigurator
    constructor: (@locator) ->

    configChanged: (@config) ->

    getArguments: (target = null) ->
        args = [@locator.getBinary(), '-utr', '+verbose']

        args = args.concat ['-mcn', @config.maxChildrenNumber] if @config?.maxChildrenNumber
        args.push '-ncc' if @config?.disableCodeCoverage
        args.push '--debug' if @config?.enableDebugMode
        args = args.concat ['-xc', @config.xdebugConfig] if @config?.xdebugConfig
        args.push '-fivm' if @config?.failIfVoidMethod
        args.push '-fism' if @config?.failIfSkippedMethod

        if target
            if fs.statSync(target).isDirectory()
                args = args.concat ['-d', target]
            else
                args = args.concat ['-f', target]

        args
