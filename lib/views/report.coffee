{ CompositeDisposable } = require 'atom'
{ View, $ } = require 'atom-space-pen-views'

module.exports =
class AtoumReportView extends View
    @content: ->
        @div outlet: 'report', class: 'report', =>
            @ol outlet: 'treeView', class: 'tree-view list-tree has-collapsable-children focusable-panel'

            @div =>
                @ul class: 'background-message centered', =>
                    @li 'Select a failing test'

                @pre ''
                @a class: 'padded', ''

    initialize: ->
        @subscriptions = new CompositeDisposable

    dispose: ->
        @subscriptions.dispose()

    setRunner: (@runner) ->
        @reset()

        @subscriptions.add @runner.on 'start', =>
            @reset()

    setParser: (@parser) ->
        @reset()

        @subscriptions.add @parser.on 'plan', =>
            @reset()

        @subscriptions.add @parser.on 'test', (test) =>
            icons =
                'ok': 'icon-check text-success'
                'skip': 'icon-arrow-right text-warning'
                'void': 'icon-primitive-dot text-info'
                'not ok': 'icon-flame text-danger'
            colors =
                true: 'text-info'
            classId = test.class.replace(/\\/g, '/')

            if @treeView.find('[data-class="' + classId + '"]').size() is 0
                @treeView.append(
                    '<li data-class="' + classId + '" class="entry list-nested-item collapsed">' +
                        '<div class="header list-item">' +
                            '<i class="icon ' + icons[test.status] + '"></i>' +
                            '<span class="name">' + test.class  + '</span>'+
                        '</div>' +
                        '<ol class="entries list-tree"></ol>'
                    '</li>'
                )

                @treeView.find('[data-class="' + classId + '"] > .header').on 'click', (event) ->
                    $(event.delegateTarget).parents('li').toggleClass('collapsed').toggleClass('expanded')

            if test.status isnt 'ok' and not @treeView.find('[data-class="' + classId + '"] > .header .icon').hasClass(icons['not ok'])
                @treeView.find('[data-class="' + classId + '"] > .header .icon')
                    .removeClass(icons['ok'])
                    .removeClass(icons['skip'])
                    .removeClass(icons['void'])
                    .addClass(icons[test.status])

            @treeView.find('[data-class="' + classId + '"] .entries').append(
                '<li class="entry list-item">' +
                    '<i class="icon ' + icons[test.status] + '"></i>' +
                    '<span class="name">' + test.method + '</span>' +
                '</li>'
            )

            if test.status isnt 'ok'
                @treeView.find('[data-class="' + classId + '"] .entries .entry:last').on 'click', (event, elem) =>
                    @treeView.find('.selected').removeClass 'selected'
                    $(event.delegateTarget).addClass 'selected'
                    @treeView.siblings('div').find('.background-message').hide()
                    @treeView.siblings('div').find('pre').html test.diag

                    if test.file and not test.line
                        @treeView.siblings('div').find('a').html test.file
                        @treeView.siblings('div').find('a').on 'click', ->
                            atom.workspace.open test.file, searchAllPanes: true

                    if test.file and test.line
                        @treeView.siblings('div').find('a').html test.file + ':' + test.line
                        @treeView.siblings('div').find('a').on 'click', ->
                            atom.workspace.open test.file, initialLine: test.line - 1, searchAllPanes: true
    reset: ->
        @treeView.html ''
        @treeView.siblings('div').find('pre').html ''
        @treeView.siblings('div').find('.background-message').css 'display', ''
        @treeView.siblings('div').find('a').html ''
