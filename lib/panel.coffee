path = require 'path'
{ CompositeDisposable } = require 'atom'
AtoumPanelView = require './views/panel'
AtoumRunner = require './runner'
AtoumNotifier = require './notifier'
AtoumParser = require './parser'
AtomDecorator = require './decorator'
AtoumLocator = require './locator'
AtoumConfigurator = require './configurator'

module.exports =
class AtoumPanel
    state: null
    view: null
    panel: null

    constructor: (state = {}) ->
        @subscriptions = new CompositeDisposable
        @parser = new AtoumParser
        @locator = new AtoumLocator atom.packages.getLoadedPackage('atoum-plugin'), atom.project
        @configurator = new AtoumConfigurator @locator
        @runner = new AtoumRunner @configurator
        @notifier = new AtoumNotifier
        @view = new AtoumPanelView state, @runner, @parser
        @decorator = new AtomDecorator @parser

        @subscriptions.add @runner.on 'start', =>
            @parser.reset()
            @notifier.reset()
            @decorator.reset()

        @subscriptions.add @runner.on 'output', (data) => @parser.parse data

        @subscriptions.add @runner.on 'stop', (code) =>
            @parser.flush()
            @notifier.notify code

        @subscriptions.add @parser.on 'test', (test) =>
            @notifier.addTest test
            @decorator.addTest test

        @subscriptions.add @notifier.on 'dismiss', => @show()

        @subscriptions.add atom.commands.add 'atom-workspace',
            'atoum-plugin:run-directory': ({ target }) => @runner.start target
            'atoum-plugin:run-file': ({ target }) => @runner.start target

        @subscriptions.add atom.commands.add 'atom-text-editor',
            'atoum-plugin:run-current-file': => @runner.start atom.workspace.getActiveTextEditor().getPath()
            'atoum-plugin:run-current-directory': => @runner.start path.dirname atom.workspace.getActiveTextEditor().getPath()

        @subscriptions.add @notifier

        @subscriptions.add @view

    destroy: ->
        @subscriptions.dispose()

    addToWorkspace: (workspace) ->
        @panel = workspace.addBottomPanel
            item: @view,
            visible: false,
            className: 'tool-panel panel-bottom'
        @view.setPanel @panel

        @subscriptions.add atom.workspace.onDidOpen (event) =>
            @decorator.decorate event.item, event.uri

    configChanged: (@config) ->
        @runner.configChanged @config
        @configurator.configChanged @config
        @locator.configChanged @config

    show: ->
        unless @panel?.isVisible()
            @notifier.disable()
            @panel?.show()

    hide: ->
        if @panel?.isVisible()
            @notifier.enable()
            @panel?.hide()

    toggle: ->
        if @panel?.isVisible()
            @hide()
        else
            @show()

    serialize: ->
        @view.serialize()
