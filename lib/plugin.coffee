{ CompositeDisposable } = require 'atom'
AtoumPanel = require './panel'
AtoumConfiguration = require './configuration'

module.exports =
    config: AtoumConfiguration.schema()

    destroy: ->
        @deactivate()

    activate: ({ atoumPluginState } = {}) ->
        @subscriptions = new CompositeDisposable
        @panel = new AtoumPanel atoumPluginState
        @panel.addToWorkspace(atom.workspace)

        @subscriptions.add atom.config.observe 'atoum-plugin', (value) =>
            @panel.configChanged new AtoumConfiguration value

        @subscriptions.add atom.commands.add 'atom-workspace',
            'atoum-plugin:toggle': => @panel.toggle()
            'core:cancel': => @panel.hide()
            'core:close': => @panel.hide()

    deactivate: ->
        @subscriptions.dispose()
        @panel.destroy()

    serialize: ->
        atoumPluginState: @panel.serialize()
