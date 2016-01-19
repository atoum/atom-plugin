{ CompositeDisposable } = require 'atom'
{ View, $ } = require 'atom-space-pen-views'

module.exports =
class AtoumReportTreeviewBranchView extends View
    @icons:
        'ok': 'icon-check text-success'
        'skip': 'icon-arrow-right text-warning'
        'void': 'icon-primitive-dot text-info'
        'not ok': 'icon-flame text-danger'

    @content: (@test) ->
        @li class: 'entry list-item', =>
            @i outlet: 'icon', class: 'icon ' + @icons[@test.status]
            @span class: 'name', @test.method
