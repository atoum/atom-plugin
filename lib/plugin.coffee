{ CompositeDisposable } = require 'atom'
AtoumPanel = require './panel'

module.exports =
    config:
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

    destroy: ->
        @deactivate()

    activate: ({ atoumPluginState } = {}) ->
        @subscriptions = new CompositeDisposable
        @panel = new AtoumPanel atoumPluginState
        @panel.addToWorkspace(atom.workspace)

        @subscriptions.add atom.config.observe 'atoum-plugin', (value) =>
            @panel.configChanged value

        @subscriptions.add atom.commands.add 'atom-workspace',
            'atoum-plugin:toggle': => @panel.toggle()
            'core:cancel': => @panel.hide()
            'core:close': => @panel.hide()

    deactivate: ->
        @subscriptions.dispose()
        @panel.destroy()

    serialize: ->
        atoumPluginState: @panel.serialize()
