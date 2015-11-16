path = require 'path'
fs = require 'fs'

module.exports =
class AtoumLocator
    constructor: (@package, @project) ->
        @paths = [
            path.join 'bin', 'atoum'
            path.join 'vendor', 'bin', 'atoum'
            path.join 'vendor', 'atoum', 'atoum', 'bin', 'atoum'
        ]

    configChanged: (@config) ->

    getBinary: ->
        return path.join @package.path, 'resources', 'atoum.phar' if @package?.path and @config?.usePackagedPhar

        return unless @project

        for dir in @project.getPaths()
            for entry in @paths
                return path.join(dir, entry) if fs.existsSync path.join(dir, entry)

        false
