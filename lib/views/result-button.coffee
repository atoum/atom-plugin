{ View } = require 'atom-space-pen-views'
AtoumConsoleView = require './console'
AtoumReportView = require './report'

module.exports =
class AtoumResultButtonView extends View
    @content: (@model) ->
        @a click: 'toggleView', =>
            @i outlet: 'viewButton', class: 'icon icon-list-unordered'

    initialize: (@model) ->
        @displayView()

    toggleView: ->
        if @model.view is 'report'
            @model.view = 'console'
        else
            @model.view = 'report'

        @displayView()

    displayView: ->
        if @model.view is 'console'
            @viewButton.addClass('icon-list-unordered').removeClass('icon-terminal')

        if @model.view is 'report' or not @model.view
            @viewButton.addClass('icon-terminal').removeClass('icon-list-unordered')
