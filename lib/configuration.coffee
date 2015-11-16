module.exports =
class AtoumConfiguration
    @schema: ->
        usePackagedPhar:
            type: 'boolean'
            default: false
            description: 'Use the packaged atoum PHAR'
        maxChildrenNumber:
            type: 'integer'
            default: require('os').cpus().length
            description: 'Maximum number of concurrent processes'
        disableCodeCoverage:
            type: 'boolean'
            default: true
            description: 'Disable code coverage'
        enableDebugMode:
            type: 'boolean'
            default: false
            description: 'Enable debug mode'
        xdebugConfig:
            type: 'string'
            default: ''
            description: 'xDebug configuration'
        failIfVoidMethod:
            type: 'boolean'
            default: false
            description: 'Fail if there is a void method'
        failIfSkippedMethod:
            type: 'boolean'
            default: false
            description: 'Fail if there is a skipped method'
        phpPath:
            type: 'string'
            default: 'php'
            description: 'Path to the PHP binary to use'
        phpArguments:
            type: 'string'
            default: ''
            description: 'Arguments to append to the PHP command'

    constructor: (config = {}) ->
        defaults = {}

        for property, schema of AtoumConfiguration.schema()
            defaults[property] = schema.default

        for key, value of Object.assign {}, defaults, config
            Object.defineProperty this, key,
                enumerable: false
                configurable: false
                writable: false
                value: value
