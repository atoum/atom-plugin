fs = require 'fs'
path = require 'path'
AtoumLocator = require '../lib/locator'

describe 'AtoumConfigurator', ->
    project = null
    pkg = null
    locator = null

    beforeEach ->
        pkg =
            path: '/path/to/project'
        project =
            getPaths: ->
                ['/path/to/project', '/path/to/somewhere/else']
        locator = new AtoumLocator pkg, project

    it 'should search atoum binary in project paths', ->
        spyOn(fs, 'existsSync').andCallThrough()

        expect(locator.getBinary()).toBe false

        for dir in project.getPaths()
            expect(fs.existsSync).toHaveBeenCalledWith path.join(dir, 'bin', 'atoum')
            expect(fs.existsSync).toHaveBeenCalledWith path.join(dir, 'vendor', 'bin', 'atoum')
            expect(fs.existsSync).toHaveBeenCalledWith path.join(dir, 'vendor', 'atoum', 'atoum', 'bin', 'atoum')

    it 'should return the first available path', ->
        spyOn(fs, 'existsSync').andCallFake ->
            fs.existsSync.callCount > 1

        expect(locator.getBinary()).toBe path.join(project.getPaths()[0], 'vendor', 'bin', 'atoum')

        expect(fs.existsSync).toHaveBeenCalledWith path.join(project.getPaths()[0], 'bin', 'atoum')
        expect(fs.existsSync).toHaveBeenCalledWith path.join(project.getPaths()[0], 'vendor', 'bin', 'atoum')
        expect(fs.existsSync).not.toHaveBeenCalledWith path.join(project.getPaths()[0], 'vendor', 'atoum', 'atoum', 'bin', 'atoum')
        expect(fs.existsSync).not.toHaveBeenCalledWith path.join(project.getPaths()[1], 'bin', 'atoum')
        expect(fs.existsSync).not.toHaveBeenCalledWith path.join(project.getPaths()[1], 'vendor', 'bin', 'atoum')
        expect(fs.existsSync).not.toHaveBeenCalledWith path.join(project.getPaths()[1], 'vendor', 'atoum', 'atoum', 'bin', 'atoum')

    describe 'When a configuration is provided', ->
        it 'should use packaged phar', ->
            locator.configChanged usePackagedPhar: true

            expect(locator.getBinary()).toBe path.join(pkg.path, 'resources', 'atoum.phar')
