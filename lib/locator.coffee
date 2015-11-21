path = require 'path'
AtoumGlob = require './glob'

module.exports =
class AtoumLocator
    constructor: (@package, @project) ->

    configDidChange: (@config) ->

    getBinary: ->
        return path.join @package.path, 'resources', 'atoum.phar' if @package?.path and @config?.usePackagedPhar

        return unless @project

        for dir in @project.getPaths()
            try
                pattern = path.join dir, '**', 'bin', 'atoum'

                unless @config?.disableCodeCoverage
                    pattern = path.join dir, '**', 'atoum', 'scripts', 'coverage.php'

                AtoumGlob.init()
                files = AtoumGlob.readdirSync pattern
            catch error
                files = []

            return path.sep + files[0] if files.length > 0

        false
