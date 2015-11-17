AtomPlugin = require '../lib/plugin'

describe "AtoumPlugin", ->
    [workspaceElement, activationPromise] = []

    beforeEach ->
        workspaceElement = atom.views.getView(atom.workspace)
        activationPromise = atom.packages.activatePackage('atoum-plugin')

    describe "when the atoum-plugin:toggle event is triggered", ->
        it "hides and shows the bottom panel", ->
            # Before the activation event the view is not on the DOM, and no panel
            # has been created
            expect(workspaceElement.querySelector('.atoum')).not.toExist()

            # This is an activation event, triggering it will cause the package to be
            # activated.
            atom.commands.dispatch workspaceElement, 'atoum-plugin:toggle'

            waitsForPromise ->
                activationPromise

            runs ->
                atomPluginElement = workspaceElement.querySelector('.atoum')
                expect(atomPluginElement).toExist()

                atomPluginPanel = atom.workspace.getBottomPanels()[0]
                expect(atomPluginPanel.isVisible()).toBe true
                atom.commands.dispatch workspaceElement, 'atoum-plugin:toggle'
                expect(atomPluginPanel.isVisible()).toBe false

        it "hides and shows the view", ->
            # This test shows you an integration test testing at the view level.

            # Attaching the workspaceElement to the DOM is required to allow the
            # `toBeVisible()` matchers to work. Anything testing visibility or focus
            # requires that the workspaceElement is on the DOM. Tests that attach the
            # workspaceElement to the DOM are generally slower than those off DOM.
            jasmine.attachToDOM(workspaceElement)

            expect(workspaceElement.querySelector('.atoum')).not.toExist()

            # This is an activation event, triggering it causes the package to be
            # activated.
            atom.commands.dispatch workspaceElement, 'atoum-plugin:toggle'

            waitsForPromise ->
                activationPromise

            runs ->
                # Now we can test for view visibility
                atomPluginElement = workspaceElement.querySelector('.atoum')
                expect(atomPluginElement).toBeVisible()
                atom.commands.dispatch workspaceElement, 'atoum-plugin:toggle'
                expect(atomPluginElement).not.toBeVisible()
