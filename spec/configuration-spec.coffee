AtoumConfiguration = require '../lib/configuration'

describe 'AtoumConfiguration', ->
    beforeEach ->
        @addMatchers
            toHaveTypeAndDefaultValue: (type, value) ->
                return false if @actual?.type isnt type or @actual?.default isnt value

                true

    it 'exposes configuration schema', ->
        expect(AtoumConfiguration.schema().usePackagedPhar).toHaveTypeAndDefaultValue 'boolean', false
        expect(AtoumConfiguration.schema().maxChildrenNumber).toHaveTypeAndDefaultValue 'integer', require('os').cpus().length
        expect(AtoumConfiguration.schema().disableCodeCoverage).toHaveTypeAndDefaultValue 'boolean', true
        expect(AtoumConfiguration.schema().enableDebugMode).toHaveTypeAndDefaultValue 'boolean', false
        expect(AtoumConfiguration.schema().xdebugConfig).toHaveTypeAndDefaultValue 'string', ''
        expect(AtoumConfiguration.schema().failIfVoidMethod).toHaveTypeAndDefaultValue 'boolean', false
        expect(AtoumConfiguration.schema().failIfSkippedMethod).toHaveTypeAndDefaultValue 'boolean', false
        expect(AtoumConfiguration.schema().phpPath).toHaveTypeAndDefaultValue 'string', 'php'
        expect(AtoumConfiguration.schema().phpArguments).toHaveTypeAndDefaultValue 'string', ''

    describe 'With default values', ->
        configuration = null

        beforeEach ->
            configuration = new AtoumConfiguration

        it 'should have properties with default values', ->
            expect(configuration.usePackagedPhar).toEqual false
            expect(configuration.maxChildrenNumber).toEqual require('os').cpus().length
            expect(configuration.disableCodeCoverage).toEqual true
            expect(configuration.enableDebugMode).toEqual false
            expect(configuration.xdebugConfig).toEqual ''
            expect(configuration.failIfVoidMethod).toEqual false
            expect(configuration.failIfSkippedMethod).toEqual false
            expect(configuration.phpPath).toEqual 'php'
            expect(configuration.phpArguments).toEqual ''

    describe 'With provided values', ->
        configuration = null
        values = null

        beforeEach ->
            configuration = new AtoumConfiguration values =
                usePackagedPhar: true
                maxChildrenNumber: 5
                disableCodeCoverage: false
                enableDebugMode: true
                xdebugConfig: 'xdebug.config=foobar'
                failIfVoidMethod: true
                failIfSkippedMethod: true
                phpPath: '/path/to/php'
                phpArguments: '-n -ddate.timezone=Europe/Paris'

        it 'should have properties with provided values', ->
            expect(configuration.usePackagedPhar).toEqual values.usePackagedPhar
            expect(configuration.maxChildrenNumber).toEqual values.maxChildrenNumber
            expect(configuration.disableCodeCoverage).toEqual values.disableCodeCoverage
            expect(configuration.enableDebugMode).toEqual values.enableDebugMode
            expect(configuration.xdebugConfig).toEqual values.xdebugConfig
            expect(configuration.failIfVoidMethod).toEqual values.failIfVoidMethod
            expect(configuration.failIfSkippedMethod).toEqual values.failIfSkippedMethod
            expect(configuration.phpPath).toEqual values.phpPath
            expect(configuration.phpArguments).toEqual values.phpArguments
