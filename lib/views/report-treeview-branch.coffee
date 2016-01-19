{ CompositeDisposable } = require 'atom'
{ View, $ } = require 'atom-space-pen-views'
AtoumReportTreeviewLeafView = require './report-treeview-leaf'

module.exports =
class AtoumReportTreeviewBranchView extends View
    @icons:
        'ok': 'icon-check text-success'
        'skip': 'icon-arrow-right text-warning'
        'void': 'icon-primitive-dot text-info'
        'not ok': 'icon-flame text-danger'

    @content: (@test) ->
        @li 'data-class': @test.class.replace(/\\/g, '/'), class: 'entry list-nested-item collapsed', =>
            @div outlet: 'header', class: 'header list-item', click: 'toggle', =>
                @i outlet: 'icon', class: 'icon ' + @icons[@test.status]
                @span class: 'name', @test.class
            @ol outlet: 'leafs', class: 'entries list-tree'

    toggle: ->
        @header.toggleClass('collapsed').toggleClass('expanded')

    testDidFinish: (test) ->
        if test.status isnt 'ok' and not @icon.hasClass(icons['not ok'])
            @icon
                .removeClass(icons['ok'])
                .removeClass(icons['skip'])
                .removeClass(icons['void'])
                .addClass(icons[test.status])

        @leafs.append new AtoumReportTreeviewLeafView test
