fs = require 'fs'
path = require 'path'
tmp = require 'os-tmpdir'
xml = require 'xml2js'
{ Emitter } = require 'atom'

class File
    path: null
    lines: null

module.exports =
class AtoumCoverage extends Emitter
    configDidChange: (@config) ->

    runnerDidStop: ->
        return if @config?.disableCodeCoverage

        fs.readFile path.join(tmp(), 'clover.xml'), (err, data) =>
            return if err

            xml.parseString data, (err, result) =>
                return if err

                result?.coverage?.project?.forEach (project) =>
                    project.package?.forEach (pkg) =>
                        pkg.file?.forEach ({ $, line }) =>
                            file = new File
                            file.path = $.path
                            file.lines = []

                            line?.forEach ({ $ }) ->
                                file.lines.push([$.num, $.count])

                            @emit 'file', file
