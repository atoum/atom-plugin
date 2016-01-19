{ CompositeDisposable } = require 'atom'
{ View, $ } = require 'atom-space-pen-views'
AtoumReportTreeviewBranchView = require './report-treeview-branch'

module.exports =
class AtoumReportTreeviewView extends View
    @content: ->
        @ol outlet: 'treeView', class: 'tree-view list-tree has-collapsable-children focusable-panel'

    runnerDidStart: ->
        @reset()

    testDidFinish: (test) ->
        icons =
            'ok': 'icon-check text-success'
            'skip': 'icon-arrow-right text-warning'
            'void': 'icon-primitive-dot text-info'
            'not ok': 'icon-flame text-danger'
        colors =
            true: 'text-info'
        classId = test.class.replace(/\\/g, '/')

        if @treeView.find('[data-class="' + classId + '"]').size() is 0
            @treeView.append new AtoumReportTreeviewBranchView test

        @treeView.find('[data-class="' + classId + '"]').get(0).view().testDidFinish test

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
