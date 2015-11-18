path = require 'path'
AtoumGlob = require('../lib/glob')
AtoumLocator = require '../lib/locator'

describe 'AtoumLocator', ->
    project = null
    pkg = null
    locator = null

    beforeEach ->
        pkg =
            path: '/path/to/project'
        project =
            getPaths: ->
                ['/path/to/project', '/path/to/somewhere/else', '/path/to/nowhere']
        locator = new AtoumLocator pkg, project

    it 'should search atoum binary in project paths', ->
        spyOn(AtoumGlob, 'readdirSync').andCallFake -> []

        expect(locator.getBinary()).toBe false

        for dir in project.getPaths()
            expect(AtoumGlob.readdirSync).toHaveBeenCalledWith path.join(dir, '**', 'bin', 'atoum')

    it 'should return the first available path', ->
        spyOn(AtoumGlob, 'readdirSync').andCallFake ->
            return [path.join(project.getPaths()[0], 'vendor', 'bin', 'atoum').replace('/', '')] if AtoumGlob.readdirSync.callCount > 1
            return []

        expect(locator.getBinary()).toBe path.join(project.getPaths()[0], 'vendor', 'bin', 'atoum')

        expect(AtoumGlob.readdirSync).toHaveBeenCalledWith path.join(project.getPaths()[0], '**', 'bin', 'atoum')
        expect(AtoumGlob.readdirSync).toHaveBeenCalledWith path.join(project.getPaths()[1], '**', 'bin', 'atoum')
        expect(AtoumGlob.readdirSync).not.toHaveBeenCalledWith path.join(project.getPaths()[2], '**', 'bin', 'atoum')

    describe 'When a configuration is provided', ->
        it 'should use packaged phar', ->
            locator.configChanged usePackagedPhar: true

            expect(locator.getBinary()).toBe path.join(pkg.path, 'resources', 'atoum.phar')
