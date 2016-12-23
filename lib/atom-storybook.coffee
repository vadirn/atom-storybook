window.$ = window.jQuery = require('../node_modules/jquery')
AtomStorybookView = require './atom-storybook-view'


{CompositeDisposable} = require 'atom'

module.exports = AtomStorybook =
  AtomStorybookView: null
  panel: null
  modalPanel: null
  subscriptions: null

  isWindowResizingAllowed : true

  config:
    atomStorybookUrl:
      type: 'string'
      default: 'http://localhost:9001'

  activate: (@state) ->
    @AtomStorybookView = new AtomStorybookView(@state)
    @modalPanel = atom.workspace.addRightPanel(item: @AtomStorybookView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-storybook:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @AtomStorybookView.destroy()

  serialize: ->
    if @AtomStorybookView?
      @AtomStorybookView.serialize()
    else
      @state

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
      $('#atom-storybook').remove()
    else
      $('.storybook-view').append('<webview id="atom-storybook" src="' + atom.config.get('atom-storybook.atomStorybookUrl') + '"></webview>')
      @modalPanel.show()
