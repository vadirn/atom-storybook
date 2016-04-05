AtomStorybookView = require './atom-storybook-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomStorybook =
  atomStorybookView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomStorybookView = new AtomStorybookView(state.atomStorybookViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomStorybookView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-storybook:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomStorybookView.destroy()

  serialize: ->
    atomStorybookViewState: @atomStorybookView.serialize()

  toggle: ->
    console.log 'AtomStorybook was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
