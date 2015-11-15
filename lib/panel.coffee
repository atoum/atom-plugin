{ CompositeDisposable } = require 'atom'
AtoumPanelView = require './views/panel'
AtoumRunner = require './runner'
AtoumNotifier = require './notifier'
AtoumParser = require './parser'
AtomDecorator = require './decorator'

module.exports =
class AtoumPanel
    state: null
    view: null
    panel: null

    constructor: (state = {}) ->
        @subscriptions = new CompositeDisposable
        @parser = new AtoumParser
        @runner = new AtoumRunner @parser
        @notifier = new AtoumNotifier @runner, @parser
        @view = new AtoumPanelView state, @runner, @parser
        @decorator = new AtomDecorator @parser

        @subscriptions.add @notifier.on 'dismiss', => @show()

    destroy: ->
        @subscriptions.dispose()
        @runner.destroy()
        @notifier.destroy()
        @view.destroy()
        @decorator.destroy()

    addToWorkspace: (workspace) ->
        @panel = workspace.addBottomPanel
            item: @view,
            visible: false,
            className: 'tool-panel panel-bottom'
        @view.setPanel @panel

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
