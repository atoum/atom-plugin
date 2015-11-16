AtoumConfigurator = require '../lib/configurator'
AtoumLocator = require '../lib/locator'

describe 'AtoumConfigurator', ->
    configurator = null
    locator = null

    beforeEach ->
        locator = new AtoumLocator
        configurator = new AtoumConfigurator locator

    it 'should get binary path from locator', ->
        spyOn(locator, 'getBinary').andReturn('/path/to/atoum/binary')

        expect(configurator.getArguments()).toContain '/path/to/atoum/binary'
        expect(locator.getBinary).toHaveBeenCalled()

    it 'should enable TAP report', ->
        expect(configurator.getArguments()).toContain '-utr'

    it 'should enable verbose output', ->
        expect(configurator.getArguments()).toContain '+verbose'

    describe 'When a configuration is provided', ->
        it 'should limit child process number', ->
            configurator.configChanged maxChildrenNumber: 4

            expect(configurator.getArguments().slice(-2)).toEqual ['-mcn', 4]

        it 'should disable code coverage', ->
            configurator.configChanged disableCodeCoverage: true

            expect(configurator.getArguments()).toContain '-ncc'

        it 'should enable debug mode', ->
            configurator.configChanged enableDebugMode: true

            expect(configurator.getArguments()).toContain '--debug'

        it 'should set xDebug configuration', ->
            configurator.configChanged xdebugConfig: 'xdebug.config=foobar'

            expect(configurator.getArguments().slice(-2)).toEqual ['-xc', 'xdebug.config=foobar']

        it 'should enable failure on void method', ->
            configurator.configChanged failIfVoidMethod: true

            expect(configurator.getArguments()).toContain '-fivm'

        it 'should enable failure on skipped method', ->
            configurator.configChanged failIfSkippedMethod: true

            expect(configurator.getArguments()).toContain '-fism'
