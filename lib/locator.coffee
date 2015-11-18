path = require 'path'
AtoumGlob = require './glob'

module.exports =
class AtoumLocator
    constructor: (@package, @project) ->

    configChanged: (@config) ->

    getBinary: ->
        return path.join @package.path, 'resources', 'atoum.phar' if @package?.path and @config?.usePackagedPhar

        return unless @project

        for dir in @project.getPaths()
            try
                files = AtoumGlob.readdirSync path.join dir, '**', 'bin', 'atoum'
            catch error
                files = []

            return path.sep + files[0] if files.length > 0

        false
