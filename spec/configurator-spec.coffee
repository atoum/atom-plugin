AtoumConfigurator = require '../lib/configurator'
AtoumLocator = require '../lib/locator'
AtoumConfiguration = require '../lib/configuration'

describe 'AtoumConfigurator', ->
    configurator = null
    locator = null
    configuration = null

    beforeEach ->
        @addMatchers
            toHaveArgumentsInThisOrder: (args...) ->
                lastIndex = -1
                matched = 0

                for expected in args
                    if (lastIndex is -1 and @actual.indexOf(expected) > lastIndex) or (@actual.indexOf(expected) is lastIndex + 1)
                        ++matched
                        lastIndex = @actual.indexOf expected
                    else
                        matched = 0
                        lastIndex = -1

                matched is args.length

    beforeEach ->
        locator = new AtoumLocator
        configurator = new AtoumConfigurator locator

    beforeEach ->
        spyOn(locator, 'getBinary').andReturn('/path/to/atoum/binary')

    afterEach ->
        expect(locator.getBinary).toHaveBeenCalled()

    it 'should get binary path from locator', ->
        expect(configurator.getArguments()).toContain '/path/to/atoum/binary'

    it 'should enable TAP report', ->
        expect(configurator.getArguments()).toContain '-utr'

    it 'should enable verbose output', ->
        expect(configurator.getArguments()).toContain '+verbose'

    describe 'When a configuration is provided', ->
        it 'should limit child process number', ->
            configurator.configChanged new AtoumConfiguration
                maxChildrenNumber: 4

            expect(configurator.getArguments()).toHaveArgumentsInThisOrder '-mcn', 4

        it 'should disable code coverage', ->
            configurator.configChanged new AtoumConfiguration
                disableCodeCoverage: true

            expect(configurator.getArguments()).toContain '-ncc'

        it 'should enable debug mode', ->
            configurator.configChanged new AtoumConfiguration
                enableDebugMode: true

            expect(configurator.getArguments()).toContain '--debug'

        it 'should set xDebug configuration', ->
            configurator.configChanged new AtoumConfiguration
                xdebugConfig: 'xdebug.config=foobar'

            expect(configurator.getArguments()).toHaveArgumentsInThisOrder '-xc', 'xdebug.config=foobar'

        it 'should enable failure on void method', ->
            configurator.configChanged new AtoumConfiguration
                failIfVoidMethod: true

            expect(configurator.getArguments()).toContain '-fivm'

        it 'should enable failure on skipped method', ->
            configurator.configChanged new AtoumConfiguration
                failIfSkippedMethod: true

            expect(configurator.getArguments()).toContain '-fism'

        it 'should use the provided PHP binary', ->
            configurator.configChanged new AtoumConfiguration
                phpPath: '/path/to/php'

            expect(configurator.getArguments()).toHaveArgumentsInThisOrder '-p', '/path/to/php'

        it 'should use the provided PHP arguments', ->
            configurator.configChanged new AtoumConfiguration
                phpArguments: '-n -ddate.timezone=Europe/Paris'

            expect(configurator.getArguments().slice(0, 2)).toHaveArgumentsInThisOrder '-n', '-ddate.timezone=Europe/Paris'
            expect(configurator.getArguments()).toHaveArgumentsInThisOrder '-p', 'php -n -ddate.timezone=Europe/Paris'

        it 'should use the provided PHP binary and arguments', ->
            configurator.configChanged new AtoumConfiguration
                phpPath: '/path/to/php'
                phpArguments: '-n -ddate.timezone=Europe/Paris'

            expect(configurator.getArguments().slice(0, 2)).toHaveArgumentsInThisOrder '-n', '-ddate.timezone=Europe/Paris'
            expect(configurator.getArguments()).toHaveArgumentsInThisOrder '-p', '/path/to/php -n -ddate.timezone=Europe/Paris'
