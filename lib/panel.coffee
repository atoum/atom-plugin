path = require 'path'
{ CompositeDisposable } = require 'atom'
{ $ } = require 'atom-space-pen-views'
AtoumPanelView = require './views/panel'
AtoumRunner = require './runner'
AtoumNotifier = require './notifier'
AtoumParser = require './parser'
AtomDecorator = require './decorator'
AtoumLocator = require './locator'
AtoumConfigurator = require './configurator'
AtoumCoverage = require './coverage'

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
        @notifier = new AtoumNotifier atom.notifications
        @view = new AtoumPanelView state, @runner
        @decorator = new AtomDecorator
        @coverage = new AtoumCoverage

        @subscriptions.add @runner.on 'start', =>
            @parser.runnerDidStart()
            @notifier.runnerDidStart()
            @decorator.runnerDidStart()
            @view.runnerDidStart()

        @subscriptions.add @runner.on 'output', (data) =>
            @parser.runnerDidProduceOutput data
            @view.runnerDidProduceOutput data

        @subscriptions.add @runner.on 'error', (data) =>
            @view.runnerDidProduceError data

        @subscriptions.add @runner.on 'stop', (code) =>
            @parser.runnerDidStop code
            @notifier.runnerDidStop code
            @view.runnerDidStop()
            @coverage.runnerDidStop()

        @subscriptions.add @parser.on 'plan', (length) =>
            @view.testPlanDidStart length

        @subscriptions.add @parser.on 'test', (test) =>
            @notifier.testDidFinish test
            @decorator.testDidFinish test
            @view.testDidFinish test

        @subscriptions.add @notifier.on 'dismiss', =>
            @show()

        @subscriptions.add @coverage.on 'file', (file) =>
            @decorator.fileDidCover file

        @subscriptions.add atom.commands.add 'atom-workspace',
            'atoum-plugin:run-directory': ({ target }) => @runItem target
            'atoum-plugin:run-file': ({ target }) => @runItem target

        @subscriptions.add atom.commands.add 'atom-text-editor',
            'atoum-plugin:run-current-file': =>
                @runner.shouldRunFile atom.workspace.getActiveTextEditor().getPath()
            'atoum-plugin:run-current-directory': =>
                @runner.shouldRunDirectory path.dirname atom.workspace.getActiveTextEditor().getPath()

        @subscriptions.add @view
        @subscriptions.add @runner
        @subscriptions.add @parser
        @subscriptions.add @notifier
        @subscriptions.add @decorator
        @subscriptions.add @coverage

    destroy: ->
        @subscriptions.dispose()

    addToWorkspace: (workspace) ->
        @panel = workspace.addBottomPanel
            item: @view,
            visible: false,
            className: 'tool-panel panel-bottom'
        @view.setPanel @panel

        @subscriptions.add workspace.onDidOpen (event) =>
            @decorator.editorDidOpenFile event.item, event.uri

    configDidChange: (config) ->
        @runner.configDidChange config
        @configurator.configDidChange config
        @locator.configDidChange config
        @notifier.configDidChange config
        @coverage.configDidChange config

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

    runItem: (item) ->
        if item instanceof HTMLElement
            unless $(item).is('span')
                item = $(item).find 'span'

            item = $(item).attr 'data-path'

        return unless item

        @runner.shouldRunFile(item) unless @runner.shouldRunDirectory(item)


    serialize: ->
        @view.serialize()
